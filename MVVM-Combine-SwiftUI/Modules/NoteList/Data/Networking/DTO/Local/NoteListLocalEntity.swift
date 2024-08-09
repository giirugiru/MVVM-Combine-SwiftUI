//
//  NoteListLocalEntity.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 09/08/24.
//

import Foundation
import SwiftData

@Model
class NoteListLocalEntity {
    @Attribute(.unique) var id: String
    var title: String
    var todoCount: Int
    var completed: Bool
    
    init(id: String, title: String, todoCount: Int, completed: Bool) {
        self.id = id
        self.title = title
        self.todoCount = todoCount
        self.completed = completed
    }
    
    func toDomain() -> NoteListModel {
        return .init(
            id: self.id,
            title: self.title,
            todoCount: self.todoCount,
            completed: self.completed
        )
    }
}
