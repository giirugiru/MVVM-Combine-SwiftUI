//
//  ContentView.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 24/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NoteListViewControllerRepresentable()
                    .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
