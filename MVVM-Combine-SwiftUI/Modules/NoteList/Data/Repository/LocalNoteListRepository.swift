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
    
    func save(param: NoteListRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let entity = NoteListLocalEntity(
                        id: param.id,
                        title: param.title,
                        todoCount: param.todoCount,
                        completed: false)
                    
                    self.container?.mainContext.insert(entity)
                    
                    try self.container?.mainContext.save()
                    
                    promise(.success(true))
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
                let id = param.id
                let fetchDescriptor = FetchDescriptor<NoteListLocalEntity>(
                    predicate: #Predicate {
                        $0.id == id
                    }
                )
                
                let result = Result {
                    do {
                        if let entity = try self.container?.mainContext.fetch(fetchDescriptor).first {
                            entity.completed = param.completed
                            try self.container?.mainContext.save()
                            return EmptyResponse()
                        } else {
                            throw NetworkError.noData
                        }
                    } catch {
                        throw error
                    }
                }
                
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(.genericError(error: error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func delete(id: String) -> AnyPublisher<EmptyResponse, NetworkError> {
        return Future<EmptyResponse, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let fetchDescriptor = FetchDescriptor<NoteListLocalEntity>(
                        predicate: #Predicate {
                            $0.id == id
                        }
                    )
                    
                    let result = Result {
                        do {
                            if let entity = try self.container?.mainContext.fetch(fetchDescriptor).first {
                                self.container?.mainContext.delete(entity)
                                try self.container?.mainContext.save()
                                return EmptyResponse()
                            } else {
                                throw NetworkError.noData
                            }
                        } catch {
                            throw error
                        }
                    }
                    
                    switch result {
                    case .success(let response):
                        promise(.success(response))
                    case .failure(let error):
                        promise(.failure(.genericError(error: error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
