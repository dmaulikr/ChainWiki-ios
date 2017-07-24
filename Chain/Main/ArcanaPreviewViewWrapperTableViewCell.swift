//
//  ArcanaPreviewViewWrapperCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/23/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewViewWrapperTableViewCell: UITableViewCell {

    @IBOutlet weak var arcanaPreviewView: ArcanaPreviewView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        arcanaPreviewView.arcanaNickKRLabel.text = nil
        arcanaPreviewView.arcanaNickJPLabel.text = nil
        arcanaPreviewView.arcanaAffiliationLabel.text = nil
    }

}
