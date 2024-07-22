//
//  NoteListResponseDTO.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

internal struct NoteListResponseDTO: Decodable {
    
}

internal extension NoteListResponseDTO {
    func toDomain() -> NoteListModel {
        return .init()
    }
}
