//
//  SwivlExamTests.swift
//  SwivlExamTests
//
//  Created by Sergiy Suprun on 3/14/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import UIKit
import XCTest

class SwivlExamTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    
    func testDataLoad() {
        // This is an example of a functional test case.
        let expectation = self.expectationWithDescription("expectDownload")
        
        NetworkManager.sharedInstance.downloadObject(User.self, handler: { (success, data, error) -> Void in
            if (success) {
                println("success:\(success), data:\(data), error:\(error)")
                let user10:User = data![10] as User
                println("user10 id:\(user10.userId) login:\(user10.login) htmlPath:\(user10.htmlUrl) avatarPath:\(user10.avatarUrl)")
            }else {
                XCTAssert(success, "Pass")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(1000, handler: { (err) -> Void in
            
        })
        
    }
    
    
    
    func testImageLoad() {
        // This is an example of a functional test case.
        let expectation = self.expectationWithDescription("expectImageLoad")
        
        let view = UIImageView()
        
        NetworkManager.sharedInstance.downloadObject(User.self, handler: { (success, data, error) -> Void in
            if (success) {
                let index = 20
                if index < data!.count {
                let user10:User = data![index] as User
                    ImageLoader.sharedInstance.downloadImage(user10.avatarUrl, view:view, handler: { (image) -> Void in
                        println("image loaded: \(image)")
                        expectation.fulfill()
                    })
                }
            }else {
                XCTAssert(success, "Pass")
            }
                    })
        
        self.waitForExpectationsWithTimeout(1000, handler: { (err) -> Void in
            
        })
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
