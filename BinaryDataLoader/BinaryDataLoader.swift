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
    case NoCache
    /// If founds it in cache returns it and stops
    case AcceptCache
    /// If founds it in cache returns the it than refreshes the cache
    case RefreshCache
    /// Returns tha cached data if ound furst, than returns the downloaded
    case Newest
}


// MARK: - Protocol for generic methods
public protocol BinaryLoadable {
    init?(data: NSData)
}

// MARK: - default generic implementations
extension UIImage: BinaryLoadable { }
extension NSData: BinaryLoadable { }

public class BinaryDataLoader {
        
    public func get<T: BinaryLoadable>(from url: String, cachePolicy: CachePolicy = .Newest, done: (data: T?) -> Void) {
        var foundInCache = false
        
        if let cachedData = try? getPersistantData(by: url) where cachePolicy != .NoCache, let validData = cachedData {
            foundInCache = true
            dispatch_async(dispatch_get_main_queue()) { done(data: T(data: validData)) }
        }
        
        if cachePolicy == .AcceptCache && foundInCache {
            return
        }
        
        downloadData(NSURL(string:  url)!) { [weak self] (data) in
            guard let validData = data else {
                done(data: nil)
                return
            }
            
            if (foundInCache && cachePolicy == .Newest) || !foundInCache {
                dispatch_async(dispatch_get_main_queue()) { done(data: T(data: validData)) }
            }
            
            if cachePolicy != .NoCache {
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

//MARK: - Download
extension BinaryDataLoader {
    
    private func downloadData(url: NSURL, done: (data: NSData?) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithURL(url) {
            (data, response, error) in
            guard data != nil else {
                done(data: nil)
                return
            }
            done(data: data)
            }.resume()
    }
}

//MARK: - Cache
extension BinaryDataLoader {
    
    private var documentsURL: NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    }
    
    private func savePersistant(data: NSData, by key: String) throws {
        let cacheUrl = documentsURL.URLByAppendingPathComponent(key.stringByReplacingOccurrencesOfString("/", withString: "_"))
        
        try data.writeToURL(cacheUrl, options: .AtomicWrite)
    }
    
    private func getPersistantData(by key: String) throws -> NSData? {
        let cacheUrl = documentsURL.URLByAppendingPathComponent(key.stringByReplacingOccurrencesOfString("/", withString: "_"))
        
        return try NSData(contentsOfURL: cacheUrl, options: .DataReadingMappedIfSafe)
    }
}