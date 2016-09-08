//
//  RarityCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/7/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RarityCell: UICollectionViewCell {
    
    @IBOutlet weak var rarity: UILabel!
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                self.contentView.backgroundColor = lightGreenColor
                rarity.textColor = UIColor.whiteColor()
            }
            else {
                self.contentView.backgroundColor = UIColor.whiteColor()
                rarity.textColor = lightGreenColor
                
            }
            super.highlighted = newValue
        }
    }
    
}
