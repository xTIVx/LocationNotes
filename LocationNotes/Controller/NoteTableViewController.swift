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

        textName.text = note?.name
        textDescription.text = note?.textDescription
        imageView.image = note?.imageeActual
        
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
            alertController.addAction(a1Camera)
            
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

    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
