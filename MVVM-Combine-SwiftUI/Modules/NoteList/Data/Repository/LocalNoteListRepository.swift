//
//  LocalNoteListRepository.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 09/08/24.
//

import Foundation
import Combine
import SwiftData

internal final class LocalNoteListRepository: NoteListRepository {
    
    private let container = SwiftDataContextManager.shared.container
    
    init() { }
    
    func fetch() -> AnyPublisher<[NoteListModel]?, NetworkError> {
        return Future<[NoteListModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let fetchDescriptor = FetchDescriptor<NoteListLocalEntity>()
                    let localNotes = try self.container?.mainContext.fetch(fetchDescriptor)
                    let models = localNotes?.compactMap { $0.toDomain() }
                    
                    promise(.success(models))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(param: NoteListRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError> {
        return Future<EmptyResponse, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let entity = NoteListLocalEntity(
                        id: param.id,
                        title: param.title,
                        todoCount: param.todoCount,
                        completed: false)
                    
                    self.container?.mainContext.insert(entity)
                    
                    try self.container?.mainContext.save()
                    
                    promise(.success(EmptyResponse()))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(param: UpdateNoteRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError> {
        return Future<EmptyResponse, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let id = param.id
                    let fetchDescriptor = FetchDescriptor<NoteListLocalEntity>(
                        predicate: #Predicate {
                            $0.id == id
                        }
                    )
                    
                    if let entity = try self.container?.mainContext.fetch(fetchDescriptor).first {
                        entity.completed = param.completed
                        
                        try self.container?.mainContext.save()
                        
                        promise(.success(EmptyResponse()))
                    } else {
                        promise(.failure(.noData))
                    }
                } catch {
                    promise(.failure(.invalidResponse))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
