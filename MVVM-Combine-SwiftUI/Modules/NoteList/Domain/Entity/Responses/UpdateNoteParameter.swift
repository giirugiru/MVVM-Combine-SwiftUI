//
//  UpdateNoteParameter.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 09/08/24.
//

import Foundation

internal struct UpdateNoteParameter {
    let id: String
    let completed: Bool
}

extension UpdateNoteParameter {
    func toRequest() -> UpdateNoteRequestDTO {
        return .init(
            id: self.id,
            completed: self.completed
        )
    }
}
