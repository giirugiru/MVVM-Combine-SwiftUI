//
//  ContentView.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 24/06/24.
//

import SwiftUI

struct ListItem {
    var text: String
    var isStrikeThrough: Bool?
}

// TODO: - You can refactor this if needed :)
class AddNoteWrapper: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var list: [String] = [
        "Complete daily workout",
        "Write in journal",
        "Meditate for 10 minutes",
        "Read 20 pages of a book",
        "Drink 8 glasses of water"
    ]
    // Add other properties as needed
}

struct ContentView: View {
    @StateObject private var addNoteWrapper = AddNoteWrapper()
    
    var body: some View {
        NavigationStack {
            NoteListViewControllerRepresentable()
                .edgesIgnoringSafeArea(.all)
                .sheet(
                    isPresented: $addNoteWrapper.isPresented,
                    content: {
                    AddNoteViewControllerRepresentable()
                })
        }
        .environmentObject(addNoteWrapper)
    }
}

#Preview {
    ContentView()
}
