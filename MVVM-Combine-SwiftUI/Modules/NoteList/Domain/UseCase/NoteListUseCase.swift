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
    func save(param: NoteListParameter) -> AnyPublisher<Bool, NetworkError>
    func update(param: UpdateNoteParameter) -> AnyPublisher<EmptyResponse, NetworkError>
    func delete(id: String) -> AnyPublisher<EmptyResponse, NetworkError>
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
    
    func save(param: NoteListParameter) -> AnyPublisher<Bool, NetworkError> {
        repository.save(param: param.toRequest())
    }
    
    func update(param: UpdateNoteParameter) -> AnyPublisher<EmptyResponse, NetworkError> {
        repository.update(param: param.toRequest())
    }
    
    func delete(id: String) -> AnyPublisher<EmptyResponse, NetworkError> {
        repository.delete(id: id)
    }
}
