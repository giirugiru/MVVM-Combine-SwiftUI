//
//  NoteListViewModel.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import Foundation
import Combine

internal final class NoteListViewModel {
    
    // MARK: - Properties
    private let coordinator: NoteListCoordinator
    private let useCase: NoteListUseCase
    private var cancelables = Set<AnyCancellable>()
    let output = Output()
    
    private var item: NoteListModel?
    
    // MARK: - Input Output Variable
    struct Input {
        let didLoad: PassthroughSubject<Void, Never>
    }
    
    class Output {
        @Published var result: NoteListResultData = .initial
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    // MARK: - Initializer
    init(
        coordinator: NoteListCoordinator,
        useCase: NoteListUseCase
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    // MARK: - Functions
    func bind(_ input: Input) {
        
        input.didLoad
            .receive(on: DispatchQueue.global())
            .flatMap {
                return self.useCase.fetch()
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let model):
                    self.item = model
                    self.output.result = .success(model)
                case .failure(let error):
                    self.output.result = .failure(error)
                }
            }
            .store(in: &cancelables)
    }
}

extension NoteListViewModel {
    enum NoteListResultData {
        case initial
        case success(NoteListModel)
        case failure(Error)
    }
}
