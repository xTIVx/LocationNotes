//
//  Folder+CoreDataClass.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 2/26/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    class func newFolder(name: String) -> Folder {
       let folder = Folder(context: CoreDataManager.sharedInstance.managedObjectContext)
        folder.name = name
        folder.dataUpdate = NSDate()
        
        
        return folder
    }
    
    func addNote() -> Note{
        let newNote = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        
        newNote.folder = self
        newNote.dataUpdate = NSDate()
        
        return newNote
    }
    
    var notesSorted: [Note] {
        
        let sortDescriptor = NSSortDescriptor(key: "dataUpdate", ascending: false)
        return self.notes?.sortedArray(using: [sortDescriptor]) as! [Note]
    }
    
}
