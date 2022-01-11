//
//  ToDo_AppTests.swift
//  ToDo AppTests
//
//  Created by Ayush Tiwari on 17/02/21.
//

import XCTest
@testable import ToDo_App

class ToDo_AppTests: XCTestCase {

    var testHomeScreenViewModel: HomeScreenViewModel?
    var testNotes: [Note] = []
    var testText: String = ""
    var testTime: String = ""
//    var testNotificationTime: Date
    
    override func setUp() {
        super.setUp()
        testHomeScreenViewModel = HomeScreenViewModel()
        self.testText = "This is a test note, let me test the testing tests okay tester?"
        self.testTime = testHomeScreenViewModel?.currTimestamp() ?? ""
    }

    override func tearDown() {
        testHomeScreenViewModel = nil
        super.tearDown()
    }
    
    func testNewNote() {
        
    }
}
