//
//  ArcanaButtonsCell.swift
//  Chain
//
//  Created by Jitae Kim on 10/10/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaButtonsCell: UITableViewCell {

    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var favorite: UIButton!
    
    @IBAction func toggleHeart(_ sender: UIButton!) {
        if (sender.isSelected) {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
            sender.bounceAnimate()
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton!) {
        if (sender.isSelected) {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
            sender.bounceAnimate()
        }
    }

    @IBOutlet weak var numberOfLikes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
