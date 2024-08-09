//
//  NoteListUseCaseTestCase.swift
//  MVVM-Combine-SwiftUI-Tests
//
//  Created by Achmad Fauzan on 03/08/2024.
//

import Combine
import XCTest
@testable import MVVM_Combine_SwiftUI

final class NoteListUseCaseTestCase: XCTestCase {
    private var useCase: NoteListUseCase!
    private var repository: NoteListRepositoryStub!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        repository = NoteListRepositoryStub()
        useCase = DefaultNoteListUseCase(repository: repository)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetList() {
        let response = useCase.fetch()

        response.sink { _ in

        } receiveValue: { response in
            guard let response = response else {
                return XCTFail("Failed to get note list response")
            }

            XCTAssertEqual(response[0].id, "1219c34b-811f-44ab-a23a-c808cca6fd23")
        }
        .store(in: &cancellables)
    }
}

struct NoteListRepositoryStub: NoteListRepository {
    func delete(id: String) -> AnyPublisher<EmptyResponse, NetworkError> {
        #warning("Implement this later (or not)")
        return Just(.init())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func update(param: UpdateNoteRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError> {
        #warning("Implement this later (or not)")
        return Just(.init())
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func save(param: NoteListRequestDTO) -> AnyPublisher<EmptyResponse, NetworkError> {
        #warning("Implement this later (or not)")
        return Just(.init())
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    }
    
    func fetch() -> AnyPublisher<[NoteListModel]?, NetworkError> {
        guard let response: BaseResponse = GetFile<BaseResponse<[NoteListResponseDTO]>>().load(fileName: "ListResponse") else {
            return Just<[NoteListModel]?>(nil)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }

        return Just<[NoteListModel]?>(response.payload?.map { list in
            list.toDomain()
        })
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    }
}
