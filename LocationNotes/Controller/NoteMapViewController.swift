//
//  NoteMapViewController.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/9/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit
import MapKit

class NoteAnnotation:NSObject, MKAnnotation {
    
    var note: Note
    
    var coordinate: CLLocationCoordinate2D
    
    
    // Title and subtitle for use by selection UI.
    var title: String?
    var subtitle: String?
    
    init(note: Note) {
        self.note = note
        title = note.name
        
        if note.locationActual != nil {
        coordinate = CLLocationCoordinate2D(latitude: note.locationActual!.lat, longitude: note.locationActual!.lon)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}

class NoteMapViewController: UIViewController {

    var note: Note?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        if note?.locationActual != nil {
            mapView.addAnnotation(NoteAnnotation(note: note!))
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: (note!.locationActual!.lat), longitude: note!.locationActual!.lon)
        }
        
        let ltgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        
        mapView.gestureRecognizers = [ltgr]
        
    }
    
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        let point = recognizer.location(in: mapView)
        let c = mapView.convert(point, toCoordinateFrom: mapView)
        
        note?.locationActual = LocationCoordinate(lat: c.latitude, lon: c.longitude)
        CoreDataManager.sharedInstance.saveContext()
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(NoteAnnotation(note: note!))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoteMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.isDraggable = true
        return pin
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
           let newLocation = LocationCoordinate(lat: (view.annotation?.coordinate.latitude)!, lon: (view.annotation?.coordinate.longitude)!)
            note?.locationActual = newLocation
            CoreDataManager.sharedInstance.saveContext()
        }
    }
}
