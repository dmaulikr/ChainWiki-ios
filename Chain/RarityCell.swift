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
    @IBOutlet weak var rarityIcon: UIImageView!
    
    override func awakeFromNib() {
        rarity.highlightedTextColor = UIColor.white
        rarityIcon.highlightedImage = UIImage(named: "starWhite.png")
        let backgroundView = UIView()
        backgroundView.backgroundColor = lightGreenColor
        self.selectedBackgroundView = backgroundView
    }

    
//    override var highlighted: Bool {
//        get {
//            return super.highlighted
//        }
//        set {
//            if newValue {
//                self.contentView.backgroundColor = lightGreenColor
//                rarity.textColor = UIColor.whiteColor()
//                rarityIcon.image = UIImage(named: "starWhite.png")
//            }
//            else {
//                self.contentView.backgroundColor = UIColor.whiteColor()
//                rarity.textColor = lightGreenColor
//                rarityIcon.image = UIImage(named: "starGray.png")
//            }
//            super.highlighted = newValue
//        }
//    }
    
}
