//
//  MVVM_Combine_SwiftUIApp.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 24/06/24.
//

import netfox
import SwiftUI

@main
struct MVVM_Combine_SwiftUIApp: App {

    init() {
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
