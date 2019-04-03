//
//  MapViewController.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/10/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let ltgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        
        mapView.gestureRecognizers = [ltgr]
        
    }
    
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        let point = recognizer.location(in: mapView)
        let c = mapView.convert(point, toCoordinateFrom: mapView)
        
       let newNote = Note.newNote(name: "", inFolder: nil)
        newNote.locationActual = LocationCoordinate(lat: c.latitude, lon: c.longitude)
        
        let noteController = storyboard?.instantiateViewController(withIdentifier: "noteSID") as! NoteTableViewController
        noteController.note = newNote
        
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        for note in notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
                
            }
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            DispatchQueue.main.async {
        
            mapView.setCenter(annotation.coordinate, animated: true)
            }
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        
        return pin
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedNote = (view.annotation as! NoteAnnotation).note
        let noteController = storyboard?.instantiateViewController(withIdentifier: "noteSID") as! NoteTableViewController
        noteController.note = selectedNote
        
        navigationController?.pushViewController(noteController, animated: true)
        
    }
}
