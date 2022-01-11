//
//  NotesTableViewCell.swift
//  ToDo App
//
//  Created by Ayush Tiwari on 17/02/21.
//

import UIKit

protocol TableCellDelegate: class {
    func deleteNote(index: Int)
    func editNote(index: Int)
}

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var editNoteButton: UIButton!
    @IBOutlet weak var deleteNoteButton: UIButton!
    
    weak var tableViewCellDelegate: TableCellDelegate?
    static let identifier = "NotesTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didEditButton(_ sender: Any) {
        tableViewCellDelegate?.editNote(index: editNoteButton.tag)
    }
    
    @IBAction func didDeleteButton(_ sender: Any) {
        tableViewCellDelegate?.deleteNote(index: editNoteButton.tag)
    }
    
    func configure(with viewModel: HomeScreenViewModel , index: Int) {
        editNoteButton.tag = index
        self.noteLabel.text = viewModel.getNoteLabel(index)
        self.timeLabel.text = viewModel.getTimeLabel(index)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = viewModel.setNoteColor(index)
        editNoteButton.isHidden = false
        deleteNoteButton.isHidden = false
        self.noteLabel.textAlignment = .left
        self.noteLabel.textColor = .black
    }
    
    func configureEmpty() {
        self.noteLabel.text = "Nothing todo!"
        self.noteLabel.textColor = .systemGray
        self.noteLabel.textAlignment = .center
        self.timeLabel.text = ""
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .white
        editNoteButton.isHidden = true
        deleteNoteButton.isHidden = true
    }
}
