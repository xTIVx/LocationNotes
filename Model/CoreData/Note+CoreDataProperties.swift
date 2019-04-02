//
//  Note+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 2/26/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var name: String?
    @NSManaged public var textDescription: String?
    @NSManaged public var imageSmall: NSData?
    @NSManaged public var dataUpdate: NSDate?
    @NSManaged public var folder: Folder?
    @NSManaged public var location: Location?
    @NSManaged public var image: ImageNote?

}
