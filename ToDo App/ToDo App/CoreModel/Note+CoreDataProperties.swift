//
//  Note+CoreDataProperties.swift
//  ToDo App
//
//  Created by Ayush Tiwari on 23/02/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var color: String?
    @NSManaged public var note: String?
    @NSManaged public var notifTime: Date?
    @NSManaged public var time: String?
    @NSManaged public var notifIdentifier: String?

}

extension Note : Identifiable {

}
