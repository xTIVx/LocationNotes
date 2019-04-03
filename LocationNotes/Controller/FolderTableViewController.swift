//
//  FolderTableViewController.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/3/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit

class FolderTableViewController: UITableViewController {
    
    var buyingForm = BuyingForm()

    var folder : Folder?
    var notesActual: [Note] {
        if let folder = folder {
            return folder.notesSorted
        }else {
            return notes
        }
    }
    
    var selectedNote: Note?
    
    @IBAction func pushAddAction(_ sender: UIBarButtonItem) {
        
        if buyingForm.isNeedToShow {
            buyingForm.showForm(inController: self)
            return
        }
        
        selectedNote = Note.newNote(name: "Test", inFolder: folder)
        selectedNote?.addCurrentLocation()
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNote" {
            (segue.destination as! NoteTableViewController).note = selectedNote
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let folder = folder {
            navigationItem.title = folder.name
        }else {
            navigationItem.title = "All notes"
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesActual.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath) as! NoteCell

        let noteInCell = notesActual[indexPath.row]
        
        cell.initCell(note: noteInCell)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let noteInCell = notesActual[indexPath.row]
        selectedNote = noteInCell
        performSegue(withIdentifier: "goToNote", sender: self)
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.sharedInstance.managedObjectContext.delete(notesActual[indexPath.row])
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
