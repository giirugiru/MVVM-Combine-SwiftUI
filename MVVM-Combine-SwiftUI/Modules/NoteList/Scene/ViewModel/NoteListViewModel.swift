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
    
    // MARK: - Input Output Variable
    struct Input {
        let didLoad: PassthroughSubject<Void, Never>
    }
    
    class Output {
        
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
        
    }
}
