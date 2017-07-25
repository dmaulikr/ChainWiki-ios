//
//  ArcanaPreviewHorizontalCollectionViewWrapperTableViewCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/24/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewHorizontalCollectionViewWrapperTableViewCell: BaseTableViewCell {

    let arcanaPreviewHorizontalCollectionView = ArcanaPreviewHorizontalCollectionView()
    
    override func setupViews() {
        addSubview(arcanaPreviewHorizontalCollectionView)
        arcanaPreviewHorizontalCollectionView.anchorEdgesToSuperview()
    }
    
}
