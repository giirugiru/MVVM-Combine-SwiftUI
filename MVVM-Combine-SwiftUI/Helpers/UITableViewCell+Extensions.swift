//
//  UITableViewCell+Extensions.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 05/08/24.
//

import UIKit

extension UITableViewCell {

    /// Returns the cell identifier based on the class name.
    public static var cellIdentifier: String {
        return String(describing: self)
    }

    /// Returns the nib name based on the class name.
    public static func nibName() -> String {
        return cellIdentifier + "XIB"
    }
}
