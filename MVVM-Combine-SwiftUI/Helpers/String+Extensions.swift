//
//  String+Extensions.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Kevin Abram on 26/07/24.
//

import UIKit

extension String {
    /// Strikethrough Style String
    func setStrikethrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }

    /// Normal String
    func setNormalString() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.removeAttribute( NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}
