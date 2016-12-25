//
//  languageTests.swift
//  languageTests
//
//  Created by Arif Khan on 11/5/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import XCTest
import XCTest
@testable import language

class languageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWordWebAPICall() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expect = expectation(description: "calling web api")
        
        
        let jsonWord = JsonWord(sourceWord: "Sky", translatedWord: "Asman", language: "Urdu", publishedDate: "12/14/2016", publishedBy: "arif.khan@snnab.com")
        
        LanguageApi.sharedInstance.postWord(jsonWord as JsonWord) { (result, error) in
            if let error = error {
               
                print(error)
                 expect.fulfill()
            } else {
                DispatchQueue.main.async( execute: {
                    print ("added")
                    expect.fulfill()
                })
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            XCTAssertNil(error, "Test timed out. \(error?.localizedDescription)")

        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
