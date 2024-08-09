//
//  NoteListTableViewCell.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Kevin Abram on 26/07/24.
//

import UIKit

protocol NoteListTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(at indexPath: IndexPath?)
}

class NoteListTableViewCell: UITableViewCell {
    
    weak var delegate: NoteListTableViewCellDelegate?
    private var indexPath: IndexPath?
    private var originalText: String = ""

    @IBOutlet weak var noteListLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    func setText(text: String, indexPath: IndexPath, delegate: NoteListTableViewCellDelegate?) {
        originalText = text
        self.indexPath = indexPath
        self.delegate = delegate
        setCellSelected(selected: isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setCellSelected(selected: selected)
    }
    
    func setCellSelected(selected: Bool) {
        if selected {
            noteListLabel.attributedText = originalText.setStrikethrough()
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            noteListLabel.attributedText = originalText.setNormalString()
            checkImageView.image = UIImage(systemName: "checkmark.circle")
        }
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(at: indexPath)
    }
}
