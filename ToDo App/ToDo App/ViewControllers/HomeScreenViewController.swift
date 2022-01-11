//
//  ViewController.swift
//  ToDo App
//
//  Created by Ayush Tiwari on 17/02/21.
//

import UIKit
import CoreData

class HomeScreenViewController: UIViewController, TableCellDelegate, UISearchBarDelegate, todoEditDelegate {
    
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func didTapButton(_ sender: Any) {
        noteAlert()
    }
    
    private let cellSpacingHeight: CGFloat = 10
    private var homeScreenViewModel = HomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.accessibilityIdentifier = "notesTable"
        searchBar.delegate = self
        view?.backgroundColor = .white
        setUpButton()
        homeScreenViewModel.fetchNotes()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(touchesBegan(_:with:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didTapSave(newText: String, index: Int?, notifTime: Date?) {
        if let idx = index {
            self.homeScreenViewModel.updateNote(newText, idx, notifTime)
        } else {
            self.homeScreenViewModel.addNewNote(newText, notifTime)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didCreateNotif(identifier: String, index: Int?) {
        self.homeScreenViewModel.setNewNotif(identifier: identifier, index: index)
    }
    
    func getNotifIdentifier(index: Int) -> String {
        return self.homeScreenViewModel.getNotifIdentifier(index)
    }
    
    func deleteNote(index: Int) {
        let alert = UIAlertController(title: "Are you sure you want to delete it?", message: "", preferredStyle: UIAlertController.Style.alert )
        let save = UIAlertAction(title: "Delete", style: .default) { (alertAction) in
            self.homeScreenViewModel.deleteNoteFromContext(index: index)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        self.present(alert, animated:true, completion: nil)
    }
    
    func editNote(index: Int) {
        let vc = storyboard?.instantiateViewController(identifier: "todoViewController") as! TodoViewController
        vc.delegate = self
        vc.originalText = self.homeScreenViewModel.filteredData[index].note ?? ""
        vc.index = index
        vc.headingType = "Edit"
        vc.notificationTime = self.homeScreenViewModel.notes[index].notifTime
        vc.reminderColor = self.homeScreenViewModel.noteColor[index]
        self.present(vc, animated: true, completion: nil)
    }
    
    func noteAlert() {
        let vc = storyboard?.instantiateViewController(identifier: "todoViewController") as! TodoViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.headingType = "Add"
        self.present(vc, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.homeScreenViewModel.filteredData.count == 0 {
            return 1
        }
        return self.homeScreenViewModel.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotesTableViewCell
        if self.homeScreenViewModel.filteredData.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
            cell.configureEmpty()
            cell.tableViewCellDelegate = self
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
            cell.configure(with: homeScreenViewModel, index: indexPath.section)
            cell.tableViewCellDelegate = self
        }
        return cell
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You booped me!")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension HomeScreenViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.homeScreenViewModel.filterCells(searchText: searchText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeScreenViewController {
    
    func setUpButton() {
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        addNoteButton.layer.cornerRadius = 0.5 * addNoteButton.bounds.size.width
        addNoteButton.clipsToBounds = true
        addNoteButton.backgroundColor = .systemGroupedBackground
        addNoteButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addNoteButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        addNoteButton.layer.shadowOpacity = 1.0
        addNoteButton.layer.shadowRadius = 3.0
        addNoteButton.layer.masksToBounds = false
    }
}
