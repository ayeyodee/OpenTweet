//
//  EmptyTimelineTests.swift
//  OpenTweetTests
//
//  Created by Derrick Turner on 7/24/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import OpenTweet

class EmptyTimelineTests: XCTestCase {
    
    var tl: Timeline!
    
    override func setUpWithError() throws {
        super.setUp()
        let data = try getData(fromJSON: "emptyTimeline")
        tl = try JSONDecoder().decode(Timeline.self, from: data)
    }
    
    override func tearDownWithError() throws {
        tl = nil
        super.tearDown()
      }
      
      func testJSONMapping() {
          XCTAssertEqual(tl.timeline.count, 0)
      }
}
