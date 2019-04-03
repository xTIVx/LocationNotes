//
//  FoldersTableViewController.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 3/3/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit

class FoldersTableViewController: UITableViewController {
    

    @IBAction func pushAddAction(_ sender: UIBarButtonItem) {
        
        
       let alertController = UIAlertController(title: "Create New Folder", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (text) in
            text.placeholder = "Folder Name"
        }
        
        let alertActionAdd = UIAlertAction(title: "Create", style: .default) { (alert) in
            let folderName = alertController.textFields?[0].text
            if folderName != "" {
                _ = Folder.newFolder(name: folderName!.uppercased())
                CoreDataManager.sharedInstance.saveContext()
                self.tableView.reloadData()
            }
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
        }
            alertController.addAction(alertActionAdd)
            alertController.addAction(alertActionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       LocationManager.sharedInstance.requestAuthorization()
        
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
        return folders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFolder", for: indexPath)

        let folderInCell = folders[indexPath.row]
        cell.textLabel?.text = folderInCell.name
        cell.detailTextLabel?.text = "\(folderInCell.notes!.count) item(-s)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToFolder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFolder" {
            let selectedFolder = folders[tableView.indexPathForSelectedRow!.row]
            
            (segue.destination as! FolderTableViewController).folder = selectedFolder
        }
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
            let folderInCell = folders[indexPath.row]
            
            CoreDataManager.sharedInstance.managedObjectContext.delete(folderInCell)
            CoreDataManager.sharedInstance.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .left)
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
