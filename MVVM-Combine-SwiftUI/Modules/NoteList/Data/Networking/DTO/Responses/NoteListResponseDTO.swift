//
//  NoteListResponseDTO.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

internal struct NoteListResponseDTO: Codable {
    let id: String?
    let title: String?
    let todoCount: Int?
    let completed: Bool?
}

internal extension NoteListResponseDTO {
    func toDomain() -> NoteListModel {
        return .init(
            id: self.id ?? "-",
            title: self.title ?? "-",
            todoCount: self.todoCount ?? 0,
            completed: self.completed ?? false
        )
    }
}
