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
    
    private let network = NetworkManager.shared
    private let decoder = CodableManager.shared
    
    init() { }
    
    func fetch() -> AnyPublisher<NoteListModel, Error> {
        let service = NoteListService.fetchNoteList()
        let request = network.makeRequest(service)
        
        return request.tryMap { data in
            do {
                let result = try self.decoder.decode(NoteListResponseDTO.self, from: data)
                return result.toDomain()
            } catch {
                throw error
            }
        }
        .mapError { error in
            return error
        }
        .eraseToAnyPublisher()
    }
}
