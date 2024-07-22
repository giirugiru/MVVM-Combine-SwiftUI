//
//  NoteListRepository.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation
import Combine

internal protocol NoteListRepository {
    func fetch() -> AnyPublisher<NoteListModel, Error>
}

internal final class DefaultNoteListRepository: NoteListRepository {
    
    init() { }
    
    func fetch() -> AnyPublisher<NoteListModel, Error> {
        return Future<NoteListModel, Error> { promise in
            promise(.success(.init()))
        }
        .eraseToAnyPublisher()
    }
}
