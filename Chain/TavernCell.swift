//
//  TavernCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TavernCell: UICollectionViewCell {

    @IBOutlet weak var tavernName: UILabel!
    
    override func awakeFromNib() {
        tavernName.highlightedTextColor = UIColor.white
        let backgroundView = UIView()
        backgroundView.backgroundColor = lightGreenColor
        self.selectedBackgroundView = backgroundView
        
    }
}
