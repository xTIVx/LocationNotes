//
//  LocationManager.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/9/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationCoordinate {
    var lat: Double
    var lon: Double
    
    static func create(location: CLLocation)-> LocationCoordinate {
        return LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    var manager = CLLocationManager()
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    var blockForSave: ((LocationCoordinate)->Void)?
    
    func getCurrentLocation(block: ((LocationCoordinate)->Void)?) {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            print("User is not authorized to use coordinates")
            return
        }
        
        blockForSave = block
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lc = LocationCoordinate.create(location: locations.last!)
        blockForSave?(lc)
        
        manager.stopUpdatingLocation()
    }
    
}
