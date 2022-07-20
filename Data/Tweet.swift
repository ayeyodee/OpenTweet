//
//  Tweet.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/18/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

//MARK: - Timeline
struct Timeline: Codable {
    let timeline: [Tweet]
}

//MARK: - Tweet
struct Tweet: Codable, Hashable {
    
    let id, author, content: String
    let avatar: String?
    let date: String
    let inReplyTo: String?
    
    func getFormattedDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "h:m a • MM/dd/yy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
