//
//  ArcanaPreviewWrapperCollectionViewCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewWrapperCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var arcanaPreviewView: ArcanaPreviewView!
    var arcanaID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
