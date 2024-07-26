//
//  AddNoteViewController.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Kevin Abram on 26/07/24.
//

import UIKit
import SwiftUI

protocol AddNoteViewControllerDelegate: AnyObject {
    func addNoteViewController(didAddNote note: String)
}

// TODO: - Create the other files
internal class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @Published internal var addNoteWrapper: AddNoteWrapper = .init()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AddNoteViewControllerXIB", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        addNoteWrapper.isPresented = false
    }
    
    @IBAction func didTapAddButton(_ sender: UIButton) {
        addNoteWrapper.isPresented = false
        addNoteWrapper.list.append(textView.text)
    }
}

// TODO: - Move this to other files
struct AddNoteViewControllerRepresentable: UIViewControllerRepresentable {
    
    @EnvironmentObject private var addNoteWrapper: AddNoteWrapper
    
    typealias UIViewControllerType = AddNoteViewController
    
    func makeUIViewController(context: Context) -> AddNoteViewController {
        let viewController = AddNoteViewController()
        viewController.addNoteWrapper = addNoteWrapper
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AddNoteViewController, context: Context) {}
}

