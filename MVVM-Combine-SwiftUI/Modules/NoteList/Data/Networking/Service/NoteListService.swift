//
//  NoteListService.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation

internal struct NoteListService {
    
    static func fetchNoteList() -> APIService {
        let path = "/todos/1"
        
        return APIService(
            method: .GET,
            path: path,
            headers: nil,
            params: nil,
            parameterEncoding: .json
        )
    }
}


/*
 https://jsonplaceholder.typicode.com/todos/1
 {
 "userId": 1,
 "id": 1,
 "title": "delectus aut autem",
 "completed": false
 }
 */
