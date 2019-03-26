//
//  BinaryDataLoaderTests.swift
//  BinaryDataLoaderTests
//
//  Created by Gujgiczer Máté on 15/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import XCTest
@testable import BinaryDataLoader

class BinaryDataLoaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBinaryCache() {
        let expectation = self.expectation(description: "cache")
        let loader = BinaryDataLoader()
        
        loader.get(from: "http://lorempixel.com/g/400/200/") { (data: UIImage?) in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
