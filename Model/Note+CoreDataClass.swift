//
//  Note+CoreDataClass.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 2/26/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject {
    
    class func newNote(name: String) -> Note {
        let newNote = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        newNote.name = name
        newNote.dataUpdate = NSDate()

        return newNote
    }
    
    func addImage(image: UIImage) {
       let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
        imageNote.imageBig = image.jpegData(compressionQuality: 1) as NSData?
        self.image = imageNote
    }
    func addLocation(latitude: Double, lontitude: Double) {
       let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
        location.lat = latitude
        location.lon = lontitude
        self.location = location
    }
    
    var dateUpdateString: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: self.dataUpdate as! Date)
    }
}
