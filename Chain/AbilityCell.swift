//
//  AbilityCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityCell: UITableViewCell {

    @IBOutlet weak var abilityIcon: UIImageView!
    @IBOutlet weak var abilityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
