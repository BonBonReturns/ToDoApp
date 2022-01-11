//
//  HomeScreenViewModel.swift
//  ToDo App
//
//  Created by Ayush Tiwari on 17/02/21.
//

import Foundation
import UIKit
import CoreData
import ColorsFramework

class HomeScreenViewModel {
    
    var notes: [Note] = []
    var filteredData: [Note] = []
    let noteColor = [0xd0fffd, 0xffdda, 0xe4ffde, 0xffd4fc, 0xfee7d2, 0xacddde, 0xcbe4f9, 0xc5e1a5, 0x99e6ff, 0xb8d3d8]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let colorsFramework: Colors = Colors()
    
//    let context: NSManagedObjectContext?
//    let persistentContainer: NSPersistentContainer
//    let context: NSManagedObjectContext
//
//    init() {
//        persistentContainer = NSPersistentContainer(name: "MyData")
//        persistentContainer.loadPersistentStores { description, error in
//            guard error == nil else {
//                fatalError("was unable to load store \(error!)")
//            }
//        }
//
//        context = persistentContainer.viewContext
//    }
    
    func fetchNotes() {
        do {
            self.notes = try context.fetch(Note.fetchRequest())
            self.filteredData = self.notes
        } catch {
            print("Cannot fetch data")
        }
    }
    
    func getCurrNote(index: Int) -> Note {
        return notes[index]
    }
    
    func updateNote(_ newText: String, _ index: Int, _ notifTime: Date?) {
        let noteToUpdate = notes[index]
        let cleanNewText = newText.trimmingCharacters(in: [" "]).replacingOccurrences(of: "\\n{2,}", with: "\n", options: .regularExpression)
        noteToUpdate.note = cleanNewText
        noteToUpdate.notifTime = notifTime
        do {
            try self.context.save()
            filteredData[index].note = cleanNewText
            filteredData[index].notifTime = notifTime
        } catch {
            print("Cannot Update Note!")
        }
    }
    
    func setNewNotif(identifier: String, index: Int?) {
        if let idx = index {
            notes[idx].notifIdentifier = identifier
            filteredData[idx].notifIdentifier = identifier
            print("Set notif for existing note")
        } else {
            let tempidx = notes.count - 1
            notes[tempidx].notifIdentifier = identifier
            filteredData[tempidx].notifIdentifier = identifier
            print("Set notif for new note")
        }
    }
    
    func addNewNote(_ newText: String, _ notifTime: Date?) {
        let newNote = Note(context: self.context)
        newNote.note = newText.trimmingCharacters(in: [" "]).replacingOccurrences(of: "\\n{2,}", with: "\n", options: .regularExpression)
        newNote.color = String(self.noteColor[self.notes.count%10])
        newNote.time = self.currTimestamp()
        newNote.notifTime = notifTime
        newNote.notifIdentifier = nil
        do {
            try self.context.save()
        } catch {
            print("Cannot Add Note!")
        }
        notes.insert(newNote, at: 0)
        filteredData.insert(newNote, at: 0)
    }
    
    func currTimestamp() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yy HH:mm"
        let dateformat = formatter.string(from:date)
        return dateformat
    }
    
    func deleteNoteFromContext(index: Int) {
        let noteToRemove = self.notes[index]
        let notifIdentifier: String? = getNotifIdentifier(index)
        if notifIdentifier != "" {
            if let notifIden = notifIdentifier {
                print("Printing notifIden \(notifIden)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifIden])
            } else {
                print("Cannot delete Notif or it didnt exist")
            }
        } else {
            print("Identifier nil")
        }
        self.context.delete(noteToRemove)
        do {
            try self.context.save()
        } catch {
            print("Error deleting note")
        }
        self.fetchNotes()
    }
    
    func filterCells(searchText: String) {
        filteredData = []
        if searchText.replacingOccurrences(of: " ", with: "") == "" {
            filteredData = notes
        }
        else {
            for note in notes {
                if(note.note?.lowercased().contains(searchText.trimmingCharacters(in: [" "]).lowercased()))! {
                    filteredData.append(note)
                }
            }
        }
    }
    
    func setNoteColor(_ index: Int) -> UIColor {
        colorsFramework.getOrderedColor(index: index)
    }
    
    func getNoteLabel(_ index: Int) -> String { filteredData[index].note ?? "" }
    
    func getTimeLabel(_ index: Int) -> String { filteredData[index].time ?? "" }
    
    func getNotifIdentifier(_ index: Int) -> String { filteredData[index].notifIdentifier ?? "" }
}
