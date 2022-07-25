//
//  OpenTweetUITests.swift
//  OpenTweetUITests
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest

class OpenTweetUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    
    func tweetDetailUITest() {
        
        let app = XCUIApplication()
        app.launch()
        
        let timeline = app.tables
        XCTAssertTrue(timeline.element.exists)
        
        let tweet = timeline.staticTexts["@olarivain Meh."]
        tweet.tap()
        
        let tweetNavigationBar = app.navigationBars["Tweet"]
        XCTAssertTrue(tweetNavigationBar.exists)
        
        let backButton = tweetNavigationBar.buttons["Timeline"]
        XCTAssertTrue(backButton.exists)
        
        backButton.tap()
        XCTAssertTrue(timeline.element.exists)
    }
    
}
