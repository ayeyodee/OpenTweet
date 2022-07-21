//
//  Extension.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/19/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func highlight(text: String) {
        guard let txtLabel = self.text else { return }
        
        let attributeTxt = NSMutableAttributedString(string: txtLabel)
        
        let range = attributeTxt.mutableString.range(of: "@\\w.*?\\b", options: .regularExpression, range: NSRange(location: 0, length: txtLabel.count), locale: .current)
        if range.length > 0 {
            attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
        }
        
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        matches?.forEach {
            if let range = Range($0.range, in: text) {
                let convertedRange = NSRange(range, in: text)
                attributeTxt.addAttribute(.link, value: text, range: convertedRange)
            }
        }
        self.attributedText = attributeTxt
    }
}
