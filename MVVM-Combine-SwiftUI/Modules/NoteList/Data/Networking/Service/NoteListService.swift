//
//  NoteListService.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

internal struct NoteListService {
    
    static func fetchNoteList() -> APIService {
        let path = "/todo/list"
        
        return APIService(
            method: .GET,
            path: path,
            headers: nil,
            params: nil,
            parameterEncoding: .json
        )
    }
}
