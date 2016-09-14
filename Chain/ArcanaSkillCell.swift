//
//  ArcanaSkillCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaSkillCell: UITableViewCell {

    @IBOutlet weak var skillNumber: UILabel!
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillMana: UILabel!
    @IBOutlet weak var skillManaCost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
