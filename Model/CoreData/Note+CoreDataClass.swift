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
    
    class func newNote(name: String, inFolder: Folder?) -> Note {
        let newNote = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        newNote.name = name
        newNote.dataUpdate = NSDate()
        
        if let inFolder = inFolder {
            newNote.folder = inFolder
        }

        return newNote
    }
    
    var imageeActual: UIImage? {
        set {
            if newValue == nil {
                if self.image != nil {
                    CoreDataManager.sharedInstance.managedObjectContext.delete(self.image!)
                }
                self.imageSmall = nil
            }else {
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
                }
                self.image?.imageBig = newValue!.jpegData(compressionQuality: 1) as NSData?
                self.imageSmall = newValue!.jpegData(compressionQuality: 0.05) as NSData?
            }
            dataUpdate = NSDate()
        }
        get {
            if self.image != nil {
                if image?.imageBig != nil {
                return UIImage(data: self.image!.imageBig! as Data)
                }
            }
            return nil
        }
    }
    
    var locationActual: LocationCoordinate? {
        get {
            if self.location == nil {
                return nil
            } else {
                return LocationCoordinate(lat: self.location!.lat, lon: self.location!.lon)
            }
        }
        set {
            if newValue == nil && self.location != nil {
                // Delete location
                CoreDataManager.sharedInstance.managedObjectContext.delete(self.location!)
            }
            if newValue != nil && self.location != nil {
                // Update location
                self.location?.lat = newValue!.lat
                self.location?.lon = newValue!.lon
            }
            if newValue != nil && self.location == nil {
                // Create location
                let newLocation = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
                newLocation.lat = newValue!.lat
                newLocation.lon = newValue!.lon
                self.location = newLocation
            }
        }
    }
    
    
    func addCurrentLocation() {
        LocationManager.sharedInstance.getCurrentLocation { (location) in
            self.locationActual = location
            print("Recived new location: \(location)")
        }
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
        return df.string(from: self.dataUpdate! as Date)
    }
}

