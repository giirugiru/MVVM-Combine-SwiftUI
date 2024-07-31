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
    
    var noteList: [NoteListModel] = []
    // To maintain the strikethrough
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    private let didTapReminderButtonPublisher = PassthroughSubject<Void, Never>()
    private let didMarkNote = PassthroughSubject<MarkRequest, Never>()
    private let didDeleteNote = PassthroughSubject<String, Never>()
    private let didAddNewNote = PassthroughSubject<String, Never>()
    
    // MARK: - Initialization Method
    static func create(
        with viewModel: NoteListViewModel
    ) -> NoteListViewController {
        let vc = NoteListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "NoteListViewControllerXIB", bundle: nil)
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
        tableView.register(UINib(nibName: "NoteListTableViewCellXIB", bundle: nil), forCellReuseIdentifier: "NoteListTableViewCell")
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
                    // TODO: Error Handle UI
                    print("TODO: Failed \(reason)")
                case .success(let data):
                    self.noteList = data
                    self.tableView.reloadData()
                case .loading:
                    // TODO: Handle loading UI
                    print("TODO: Handle loading UI")
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
            noteList.append(.init(id: "\(UUID())", title: title, todoCount: 0, completed: false))
            didAddNewNote.send(title)
            tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @IBAction func didTapNewReminderButton(_ sender: UIButton) {
        addNoteWrapper.isPresented = true
        // TODO: - Fix this logic?
        // didTapReminderButtonPublisher.send()
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as! NoteListTableViewCell
        let note = noteList[indexPath.row]
        cell.setText(text: note.title)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
         if noteList[indexPath.row].completed {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
         } else {
             tableView.deselectRow(at: indexPath, animated: false)
         }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            noteList.remove(at: indexPath.row)
            didDeleteNote.send(noteList[indexPath.row].id)
            tableView.reloadData()
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
