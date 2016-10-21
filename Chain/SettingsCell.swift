//
//  SettingsCell.swift
//  Chain
//
//  Created by Jitae Kim on 10/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageToggle: UISwitch!
    
    @IBAction func toggleImage(_ sender: AnyObject) {

        if defaults.getImagePermissions() {
            defaults.setImagePermissions(value: false)
            print("setting to false")
        }
        else {
            defaults.setImagePermissions(value: true)
            print("setting to true")
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
