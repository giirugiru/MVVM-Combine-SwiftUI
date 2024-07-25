//
//  NoteListResponseDTO.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

internal struct NoteListResponseDTO: Decodable {
    let userID, id: Int?
    let title: String?
    let completed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

internal extension NoteListResponseDTO {
    func toDomain() -> NoteListModel {
        return .init(title: self.title ?? "-")
    }
}
