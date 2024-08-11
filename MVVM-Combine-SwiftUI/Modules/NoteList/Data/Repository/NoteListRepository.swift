//
//  NoteListRepository.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation
import Combine

internal protocol NoteListRepository {
    func fetch() -> AnyPublisher<[NoteListModel]?, NetworkError>
    func save(param: NoteListRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError>
    func update(param: UpdateNoteRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError>
    func delete(id: String) -> AnyPublisher<EmptyResponse, NetworkError>
}

internal final class DefaultNoteListRepository: NoteListRepository {
    
    private let network = NetworkManager.shared
    
    init() { }
    
    func fetch() -> AnyPublisher<[NoteListModel]?, NetworkError> {
        let service = NoteListService.fetchNoteList()
        let request = network.makeRequest(service, output: [NoteListResponseDTO].self)

        return request.map { response in
            response.payload.map { list in
                list.compactMap { $0.toDomain() }
            }
        }.eraseToAnyPublisher()
    }
    
    func save(param: NoteListRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError> {
        #warning("TODO: Implement save")
        return Just(.init())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func update(param: UpdateNoteRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError> {
        #warning("TODO: Implement update")
        return Just(.init())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<EmptyResponse, NetworkError> {
        #warning("TODO: Implement delete")
        return Just(.init())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
