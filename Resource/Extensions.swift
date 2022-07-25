//
//  Extensions.swift
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
        
        let range = attributeTxt.mutableString.range(of: "@\\w.*?\\b",
                                                     options: .regularExpression,
                                                     range: NSRange(location: 0, length: txtLabel.count),
                                                     locale: .current)
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


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributeTxt = label.attributedText else {
            return false
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributeTxt)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension UIImageView {
    
    func imageFromURL(urlString: String?) {
        
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                ImageDownloader().getImage(withURL: url) { [weak self] image in
                    self?.image = image
                }
            } else {
                self.image = UIImage(named: "Generic")
            }
        }
    }
}

extension UIView {
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
