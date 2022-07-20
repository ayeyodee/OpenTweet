//
//  Font.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/20/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

enum Helvetica: String {
    case regular = "Helvetica"
    case light = "Helvetica-Light"
    case bold = "Helvetica-Bold"
    
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: size)
    }
}
