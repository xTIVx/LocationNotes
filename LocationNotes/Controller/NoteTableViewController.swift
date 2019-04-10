//
//  NoteTableViewController.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/3/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {

    var note : Note?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var labelFolder: UILabel!
    @IBOutlet weak var labelFolderName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true

        textName.text = note?.name
        textDescription.text = note?.textDescription
        
    if  note?.imageeActual != nil {
        imageView.image = note?.imageeActual
    }
    else {
        imageView.image = UIImage(named: "icon_photo.png")
    }
        navigationItem.title = note?.name
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let folder = note?.folder {
            labelFolderName.text = folder.name
        } else {
            labelFolderName.text = "-"
        }
    }
    
    
    func saveNote() {
        if textName.text == "" && textDescription.text == "" && imageView.image == nil{
            CoreDataManager.sharedInstance.managedObjectContext.delete(note!)
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        
        
        if note?.name != textName.text || note?.textDescription != textDescription.text{
            note?.dataUpdate = NSDate()
        }
        note?.name = textName.text
        note?.textDescription = textDescription.text
        note?.imageeActual = imageView.image
        
        CoreDataManager.sharedInstance.saveContext()
        
    }
    let imagePicker : UIImagePickerController = UIImagePickerController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            let alertController = UIAlertController(title: "Image for item", message: "", preferredStyle: .actionSheet)
            
            let a1Camera = UIAlertAction(title: "Take a picture", style: .default) { (alert) in
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front) {
            alertController.addAction(a1Camera)
            } else {
                print("Camera is not available!")
            }
            let a2Photo = UIAlertAction(title: "Select from library", style: .default) { (alert) in
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(a2Photo)
            
            if self.imageView.image != nil {
            let a3Delete = UIAlertAction(title: "Delete", style: .default) { (alert) in
                self.imageView.image = nil
                }
                alertController.addAction(a3Delete)
            }
            let a4Cancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
                
            }
            alertController.addAction(a4Cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectFolder" {
            (segue.destination as! SelectFolderTableViewController).note = note
        }
        if segue.identifier == "goToMap" {
            (segue.destination as! NoteMapViewController).note = note
        }
    }
    

    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    
    
   
    
    @IBAction func pushShareAction(_ sender: UIBarButtonItem) {
        var activities : [Any] = []
        
        if let image = note?.imageeActual {
            activities.append(image)
        }
        activities.append(note?.name ?? "")
        activities.append(note?.textDescription ?? "")
        let activityController = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    
}


extension NoteTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
