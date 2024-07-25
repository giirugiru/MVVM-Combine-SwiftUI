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
    
    private var count: Int = 0
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - Views
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        return label
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Tap me!", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        return btn
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
        bindViewModel()
    }
    
    deinit {
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    private func setupView() {
        [nameLabel, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addButton.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
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
        viewModel.output.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .initial: break
                case let .success(model):
                    print(model)
                    nameLabel.text = model.title
                case let .failure(error):
                    print(error)
                }
            }
            .store(in: &cancelables)
    }
    
    @objc
    private func didTapped() {
        debugPrint("Hello im tapped!")
        count += 1
        nameLabel.text = "Tapped \(count) times"
        didLoadPublisher.send()
    }
}

