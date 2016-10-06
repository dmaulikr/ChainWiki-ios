//
//  ManaAbilityCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/12/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ManaAbilityCell: UITableViewCell {

    @IBOutlet weak var arcanaNameKR: UILabel!
    @IBOutlet weak var arcanaNameJP: UILabel!
    @IBOutlet weak var arcanaRarity: UILabel!
    @IBOutlet weak var arcanaImage: UIImageView!
    @IBOutlet weak var imageSpinner: NVActivityIndicatorView!
    @IBOutlet weak var mana1: DrawCircle!
    @IBOutlet weak var mana2: DrawCircle!
    @IBOutlet weak var manaSub: DrawCircle!
    @IBOutlet weak var value: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        // Initialization code
//        let circle = DrawCircle()
//        circle.drawRect(CGRect(x: 0, y: 0, width: 30, height: 30))
//        self.contentView.addSubview(circle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
