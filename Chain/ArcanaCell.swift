//
//  HomeCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaCell: UITableViewCell {


    @IBOutlet weak var arcanaImage: UIImageView!
    @IBOutlet weak var arcanaNameKR: UILabel!
    @IBOutlet weak var arcanaNameJP: UILabel!
    @IBOutlet weak var arcanaRarity: UILabel!
    @IBOutlet weak var arcanaWeapon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
