//
//  NoteListTableViewCell.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Kevin Abram on 26/07/24.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {

    var originalText: String = ""

    @IBOutlet weak var noteListLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    func setText(text: String) {
        originalText = text
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
}
