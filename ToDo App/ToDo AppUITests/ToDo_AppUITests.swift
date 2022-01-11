//
//  ToDo_AppUITests.swift
//  ToDo AppUITests
//
//  Created by Ayush Tiwari on 17/02/21.
//

import XCTest

class ToDo_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_create_new_note() throws {
        let app = XCUIApplication()
        app.launch()

        let testText = "I have to buy a new charger"
        
        let addNewNoteButton = app.buttons["addNewNoteButton"]
        XCTAssertTrue(addNewNoteButton.exists)
        addNewNoteButton.tap()
        
        let newNoteText = app.textViews["newNoteText"]
        XCTAssertTrue(newNoteText.exists)
        newNoteText.typeText(testText)
        
        let notificationSwitch = app.switches["notificationSwitch"]
        XCTAssertTrue(notificationSwitch.exists)
        notificationSwitch.tap()
        
        let saveNewNote = app.buttons["saveNewNote"]
        XCTAssertTrue(saveNewNote.exists)
        saveNewNote.tap()
        
        let cellCount = app.tables["notesTable"].cells.count
        let noteLabel = app.tables["notesTable"].cells.element(boundBy: cellCount-1).staticTexts["noteLabel"]
        XCTAssertTrue(noteLabel.exists)
        
        XCTAssertEqual(noteLabel.label, testText)
        
        app.tables["notesTable"].cells.element(boundBy: cellCount-1).buttons["deleteButton"].tap()
        
        app.alerts["Are you sure you want to delete it?"].scrollViews.otherElements.buttons["Delete"].tap()
    }
    
    func test_edit_newNote() throws {
        let app = XCUIApplication()
        app.launch()
        
        let testText = "I have to buy a new charger"
        let editedText = "test"
        
        let addNewNoteButton = app.buttons["addNewNoteButton"]
        XCTAssertTrue(addNewNoteButton.exists)
        addNewNoteButton.tap()
        
        let newNoteText = app.textViews["newNoteText"]
        XCTAssertTrue(newNoteText.exists)
        newNoteText.typeText(testText)
        
        let notificationSwitch = app.switches["notificationSwitch"]
        XCTAssertTrue(notificationSwitch.exists)
        notificationSwitch.tap()
        
        let saveNewNote = app.buttons["saveNewNote"]
        XCTAssertTrue(saveNewNote.exists)
        saveNewNote.tap()
        
        let cellCount = app.tables["notesTable"].cells.count
        
        app.tables["notesTable"].cells.element(boundBy: cellCount-1).buttons["editButton"].tap()
        
        let editNewNote = app.textViews["newNoteText"]
        XCTAssertTrue(editNewNote.exists)
        
        editNewNote.typeText(editedText)
        
        saveNewNote.tap()
        
        let noteLabel = app.tables["notesTable"].cells.element(boundBy: cellCount-1).staticTexts["noteLabel"]
        XCTAssertTrue(noteLabel.exists)
        
        XCTAssertEqual(noteLabel.label, testText+editedText)
        
        app.tables["notesTable"].cells.element(boundBy: cellCount-1).buttons["deleteButton"].tap()
        
        app.alerts["Are you sure you want to delete it?"].scrollViews.otherElements.buttons["Delete"].tap()
    }
}

