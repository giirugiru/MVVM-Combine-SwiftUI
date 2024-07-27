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
    
    private var count: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var stringArray: [String] = [
        "Complete daily workout",
        "Write in journal",
        "Meditate for 10 minutes",
        "Read 20 pages of a book",
        "Drink 8 glasses of water"
    ]
    // To maintain the strikethrough
    var strikeThroughDictionary: [IndexPath: Bool] = [:]
    
    // MARK: - Publisher
    private let didLoadPublisher = PassthroughSubject<Void, Never>()
    private let didTapReminderButtonPublisher = PassthroughSubject<Void, Never>()
    
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
            didTapAddReminderButton: didTapReminderButtonPublisher
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
                    // TODO: - Integrate this logic later
                    print(model)
                    // nameLabel.text = model.title
                case let .failure(error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    // TODO: - I think this could be further improved :)
    internal func bindEnvironmentObject() {
        addNoteWrapper.$list.sink { [weak self] list in
            guard let self = self else { return }
            self.stringArray = list
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @IBAction func didTapNewReminderButton(_ sender: UIButton) {
        addNoteWrapper.isPresented = true
        // TODO: - Fix this logic?
         didTapReminderButtonPublisher.send()
    }
    
    @objc
    private func didTapped() {
        // TODO: - Integrate this logic later
//        debugPrint("Hello im tapped!")
//        count += 1
//        nameLabel.text = "Tapped \(count) times"
//        didLoadPublisher.send()
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as! NoteListTableViewCell
        let text = stringArray[indexPath.row]
        cell.setText(text: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            stringArray.remove(at: indexPath.row)
            addNoteWrapper.list.remove(at: indexPath.row)
        }
    }
    
    // TODO: - Find a way to permanently set strike through
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // strikeThroughDictionary[indexPath.row] = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // strikeThroughDictionary[indexPath.row] = false
    }
}
