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
}

internal final class DefaultNoteListRepository: NoteListRepository {
    
    private let network = NetworkManager.shared
    private let decoder = CodableManager.shared
    
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
}
