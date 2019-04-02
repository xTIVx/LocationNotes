//
//  Folder+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 2/26/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var dataUpdate: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var attribute: NSObject?
    @NSManaged public var attribute1: NSObject?
    @NSManaged public var attribute2: NSObject?
    @NSManaged public var attribute3: NSObject?
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension Folder {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
