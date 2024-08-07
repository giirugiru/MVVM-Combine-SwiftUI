//
//  UIViewController+Extensions.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 05/08/24.
//

import UIKit

extension UIViewController {

    /// Returns the nib name based on the class name.
    public static func nibName() -> String {
        return String(describing: self) + "XIB"
    }
}
