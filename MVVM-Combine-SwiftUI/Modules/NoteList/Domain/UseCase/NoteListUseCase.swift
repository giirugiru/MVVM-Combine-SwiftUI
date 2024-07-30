//
//  NoteListUseCase.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation
import Combine

internal protocol NoteListUseCase {
    func fetch() -> AnyPublisher<[NoteListModel]?, NetworkError>
}

internal final class DefaultNoteListUseCase: NoteListUseCase {
    private let repository: NoteListRepository
    
    init(
        repository: NoteListRepository
    ) {
        self.repository = repository
    }

    func fetch() -> AnyPublisher<[NoteListModel]?, NetworkError> {
        repository.fetch()
    }
    
}
