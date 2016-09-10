//
//  FilterCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var filterType: UILabel!
    
    override func awakeFromNib() {
        filterType.highlightedTextColor = UIColor.whiteColor()
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
//                filterType.textColor = UIColor.whiteColor()
//            }
//            else {
//                self.contentView.backgroundColor = UIColor.whiteColor()
//                filterType.textColor = lightGreenColor
//
//            }
//            super.highlighted = newValue
//        }
//    }

}
