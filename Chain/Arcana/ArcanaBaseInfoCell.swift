//
//  ArcanaBaseInfoCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaBaseInfoCell: UITableViewCell {
    
    @IBOutlet weak var attributeKeyFirstLabel: ArcanaAttributeHeaderLabel!
    @IBOutlet weak var attributeDescFirstLabel: ArcanaAttributeDescLabel!
    @IBOutlet weak var attributeKeySecondLabel: ArcanaAttributeHeaderLabel!
    @IBOutlet weak var attributeDescSecondLabel: ArcanaAttributeDescLabel!
    @IBOutlet weak var arcanaClassImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
