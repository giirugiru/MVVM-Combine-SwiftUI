//
//  NoteListViewController.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 22/07/24.
//

import UIKit
import Combine

internal class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: NoteListViewModel!
    private var cancelables = Set<AnyCancellable>()
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - Views
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        return label
    }()
    
    // MARK: - Initialization Method
    static func create(
        with viewModel: NoteListViewModel
    ) -> NoteListViewController {
        let vc = NoteListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    private func setupView() {
        [nameLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Bind View Model
    private func bindViewModel() {
        let input = NoteListViewModel.Input(
            didLoad: didLoadPublisher
        )
        
        viewModel.bind(input)
        bindViewModelOutput()
    }

    private func bindViewModelOutput() {

    }
}

