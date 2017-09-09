//
//  ArcanaHorizontalCollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 7/13/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

enum ArcanaSection: Int {
    case reward
    case festival
    case new
    case legend
}

class ArcanaHorizontalCollectionView: UICollectionView {
    
    var arcanaSection: ArcanaSection
    
    init(arcanaSection: ArcanaSection, collectionViewLayout: UICollectionViewLayout) {
        self.arcanaSection = arcanaSection
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
        register(ArcanaIconCell.self, forCellWithReuseIdentifier: "ArcanaIconCell")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
