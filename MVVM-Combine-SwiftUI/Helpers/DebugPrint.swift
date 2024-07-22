//
//  DebugPrint.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

func debugPrint(_ string: String) {
    #if DEBUG
    Swift.print(string)
    #endif
}
