//
//  BinaryDataLoader.swift
//  BinaryDataLoader
//
//  Created by Gujgiczer Máté on 15/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

public enum CachePolicy {
    /// Denys cache, loads all data
    case noCache
    /// If founds it in cache returns it and stops
    case acceptCache
    /// If founds it in cache returns the it than refreshes the cache
    case refreshCache
    /// Returns tha cached data if ound furst, than returns the downloaded
    case newest
}


// MARK: - Protocol for generic methods
public protocol BinaryLoadable {
    static func create(with data: Data) -> Self?
}

// MARK: - default generic implementations
extension Data: BinaryLoadable {
    public static func create(with data: Data) -> Data? {
        return data
    }
}

//MAKR: - Implementation
open class BinaryDataLoader {
    
    open func get<T: BinaryLoadable>(from url: String, cachePolicy: CachePolicy = .newest, done: @escaping (_ data: T?) -> Void) {
        var foundInCache = false
        
        if let cachedData = try? getPersistantData(by: url) , cachePolicy != .noCache, let validData = cachedData {
            foundInCache = true
            DispatchQueue.main.async { done(T.create(with: validData)) }
        }
        
        if cachePolicy == .acceptCache && foundInCache {
            return
        }
        
        downloadData(URL(string:  url)!) { [weak self] (data) in
            guard let validData = data else {
                done(nil)
                return
            }
            
            if (foundInCache && cachePolicy == .newest) || !foundInCache {
                DispatchQueue.main.async { done(T.create(with: validData)) }
            }
            
            if cachePolicy != .noCache {
                do {
                    try self?.savePersistant(validData, by: url)
                }
                catch {
                    print("binary cache error")
                }
            }
        }
    }
    
    public init() { }
}

//MARK: - Explicit UIImage support
public extension BinaryDataLoader {
    
    public func get(from url: String, cachePolicy: CachePolicy = .newest, done: @escaping (_ data: UIImage?) -> Void) {
        self.get(from: url, cachePolicy: cachePolicy) { (data: Data?) in
            guard let validData = data else {
                done(nil)
                return
            }
            done(UIImage(data: validData))
        }
    }
}

//MARK: - Download
extension BinaryDataLoader {
    
    fileprivate func downloadData(_ url: URL, done: @escaping (_ data: Data?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard data != nil else {
                done(nil)
                return
            }
            done(data)
            }) .resume()
    }
}

//MARK: - Cache
extension BinaryDataLoader {
    
    fileprivate var documentsURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    fileprivate func savePersistant(_ data: Data, by key: String) throws {
        let cacheUrl = documentsURL.appendingPathComponent(key.replacingOccurrences(of: "/", with: "_"))
        
        try data.write(to: cacheUrl, options: .atomicWrite)
    }
    
    fileprivate func getPersistantData(by key: String) throws -> Data? {
        let cacheUrl = documentsURL.appendingPathComponent(key.replacingOccurrences(of: "/", with: "_"))
        
        return try Data(contentsOf: cacheUrl, options: .mappedIfSafe)
    }
}
