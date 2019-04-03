//
//  NoteCell.swift
//  LocationNotes
//
//  Created by Igor Chernobai on 4/3/19.
//  Copyright © 2019 Igor Chernobai. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    var note: Note?
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var dateUpdateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func initCell(note: Note) {
        self.note = note
        
        
        if note.imageSmall != nil {
            imageCell.image = UIImage(data: note.imageSmall! as Data)
        } else {
            imageCell.image = UIImage(named: "icon_photo.png")
        }
        
        imageCell.layer.cornerRadius = 10
        imageCell.layer.masksToBounds = true
        
        noteNameLabel.text = note.name
        dateUpdateLabel.text = note.dateUpdateString
        if let _ = note.location {
            locationLabel.text = "Location"
        }else {
            locationLabel.text = ""
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
