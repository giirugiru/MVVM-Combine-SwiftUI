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
    private var cancellables = Set<AnyCancellable>()
    
    @Published internal var addNoteWrapper: AddNoteWrapper = .init()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var viewError: UIView!
    private var toast: LoadingToast?
    private let refreshControl = UIRefreshControl()
    
    // To maintain the strikethrough
    private var noteList: [NoteListModel] = []
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    private let didTapReminderButtonPublisher = PassthroughSubject<Void, Never>()
    private let didMarkNote = PassthroughSubject<MarkRequestModel, Never>()
    private let didDeleteNote = PassthroughSubject<String, Never>()
    private let didAddNewNote = PassthroughSubject<AddNewModel, Never>()
    
    // MARK: - Initialization Method
    static func create(
        with viewModel: NoteListViewModel
    ) -> NoteListViewController {
        let vc = NoteListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: NoteListViewController.nibName(), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        bindEnvironmentObject()
        didLoadPublisher.send()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setupView() {
        // Configure tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: NoteListTableViewCell.nibName(), bundle: nil),
            forCellReuseIdentifier: NoteListTableViewCell.cellIdentifier
        )
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewError.isHidden = true
    }

    // MARK: - Bind View Model
    private func bindViewModel() {
        let input = NoteListViewModel.Input(
            didLoad: didLoadPublisher, 
            didTapAddReminderButton: didTapReminderButtonPublisher, 
            didDeleteNote: didDeleteNote,
            didMarkNote: didMarkNote,
            didAddNewNote: didAddNewNote
        )
        
        viewModel.bind(input)
        bindViewModelOutput()
    }

    private func bindViewModelOutput() {
        viewModel.output.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failed(let reason):
                    self.lblErrorMessage.text = reason.errorMessage
                    
                    hideLoading()
                    self.refreshControl.endRefreshing()
                    self.viewError.isHidden = false
                case .success(let data):
                    self.noteList = data
                    self.tableView.reloadData()
                    
                    hideLoading()
                    self.refreshControl.endRefreshing()
                    self.viewError.isHidden = true
                case .loading:
                    showLoading()
                default:
                    return
                }
            }
            .store(in: &cancellables)

        viewModel.output.$addNote
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failed(let reason):
                    hideLoading()
                    let alertController = UIAlertController(title: "Failed Add Note", message: reason.errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        self?.viewModel.output.result = .loading
                        self?.didLoadPublisher.send()
                        alertController.dismiss(animated: true)
                    })
                    alertController.addAction(okAction)
                    present(alertController, animated: true)
                case .success(let data):
                    hideLoading()
                case .loading:
                    showLoading()
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    internal func bindEnvironmentObject() {
        addNoteWrapper.$didAddNewNote.sink { [weak self] title in
            guard let self = self, let title = title else { return }
            // TODO: - Handle ID in here
            let id = UUID().uuidString
            noteList.append(.init(id: id, title: title, todoCount: 0, completed: false))
            didAddNewNote.send(.init(id: id, title: title))
            tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @IBAction func didTapNewReminderButton(_ sender: UIButton) {
        addNoteWrapper.isPresented = true
    }

    @IBAction func didTapRetry(_ sender: Any) {
        viewModel.output.result = .loading
        didLoadPublisher.send()
    }
    
    @objc 
    private func refresh() {
        viewError.isHidden = true
        didLoadPublisher.send()
    }

    private func showLoading() {
        self.toast = LoadingToast()
        self.toast?.show(in: self.view)
        self.viewError.isHidden = true
    }

    private func hideLoading() {
        self.toast?.hide()
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.cellIdentifier, for: indexPath) as! NoteListTableViewCell
        let note = noteList[indexPath.row]
        cell.setText(text: note.title, indexPath: indexPath, delegate: self)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
         if noteList[indexPath.row].completed {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
         } else {
            tableView.deselectRow(at: indexPath, animated: false)
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeNote(indexPath: indexPath, isCompleted: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        completeNote(indexPath: indexPath, isCompleted: false)
    }
}

// Helpers
extension NoteListViewController {
    func completeNote(indexPath: IndexPath, isCompleted: Bool) {
        noteList[indexPath.row].completed = isCompleted
        didMarkNote.send(.init(id: noteList[indexPath.row].id, isCompleted: isCompleted))
    }
}

// MARK: - NoteListTableViewCellDelegate
extension NoteListViewController: NoteListTableViewCellDelegate {
    func didTapDeleteButton(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        didDeleteNote.send(noteList[indexPath.row].id)
        noteList.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
