//
//  ArcanaPreviewHorizontalswift
//  Chain
//
//  Created by Jitae Kim on 7/24/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewHorizontalCollectionView: UICollectionView {

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
   
        allowsMultipleSelection = false
        isScrollEnabled = true
        backgroundColor = .black
        alpha = 1
        
        register(UINib(nibName: "ArcanaPreviewViewWrapperCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArcanaPreviewViewWrapperCollectionViewCell")
        register(UINib(nibName: "ArcanaFullViewWrapperCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArcanaFullViewWrapperCollectionViewCell")

    }
    
    func setupCollectionView<D: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDataSourcePrefetching>(_ dataSourceDelegate: D) {

        delegate = dataSourceDelegate
        dataSource = dataSourceDelegate

    }

}
