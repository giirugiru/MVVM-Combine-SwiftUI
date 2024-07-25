//
//  NoteListCoordinator.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import SwiftUI

public final class NoteListCoordinator {
    
    // MARK: - Properties
    private var navigationController: UINavigationController?
    
    init(
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
    }

    // MARK: - Private
    // Create Document Category View Controller
    private func makeNoteListViewController() -> NoteListViewController {
        let repository = makeNoteListRepository()
        let useCase = makeNoteListUseCase(
            respository: repository
        )
        let viewModel = makeNoteListViewModel(
            useCase: useCase
        )
        let viewController = NoteListViewController.create(
            with: viewModel
        )
        return viewController
    }
    
    // Create View Model
    private func makeNoteListViewModel(
        useCase: NoteListUseCase
    ) -> NoteListViewModel {
        return NoteListViewModel(
            coordinator: self, 
            useCase: useCase
        )
    }
    
    // Create Use Case
    private func makeNoteListUseCase(
        respository: NoteListRepository
    ) -> NoteListUseCase {
        return DefaultNoteListUseCase(
            repository: respository
        )
    }
    
    // Create Repository
    private func makeNoteListRepository() -> NoteListRepository {
        return DefaultNoteListRepository()
    }
    
    // Starting Coordinator
    func route() {
        
    }
    
    func create() -> NoteListViewController {
        let vc = makeNoteListViewController()
        return vc
    }
}

struct NoteListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = NoteListViewController
    
    func makeUIViewController(context: Context) -> NoteListViewController {
        let coordinator = NoteListCoordinator(navigationController: nil)
        let viewController = coordinator.create()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: NoteListViewController, context: Context) {

    }
}
