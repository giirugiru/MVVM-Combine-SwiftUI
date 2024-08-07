//
//  NoteListModel.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

internal struct NoteListModel: Equatable {
    let id: String
    let title: String
    let todoCount: Int
    var completed: Bool
}
