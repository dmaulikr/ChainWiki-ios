//
//  ArcanaPreviewViewWrapperCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/23/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewViewWrapperCell: BaseTableViewCell {
    
    var arcanaPreviewView: ArcanaPreviewView!
    
    override func setupViews() {

        arcanaPreviewView = ArcanaPreviewView()
        addSubview(arcanaPreviewView)
        arcanaPreviewView.anchorEdgesToSuperview()
    }
    
}
