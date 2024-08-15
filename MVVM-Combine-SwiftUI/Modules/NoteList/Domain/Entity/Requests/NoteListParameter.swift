//
//  NoteListParameter.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 09/08/24.
//

import Foundation

internal struct NoteListParameter {
    let id: String
    let title: String
    let todoCount: Int
}

extension NoteListParameter {
    func toRequest() -> NoteListRequestDTO {
        return .init(
            id: self.id,
            title: self.title,
            todoCount: self.todoCount
        )
    }
}
