//
//  HomeViewTableViewCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    
    var collectionView: ArcanaHorizontalCollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView<D: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDataSourcePrefetching>(_ dataSourceDelegate: D, arcanaSection: ArcanaSection) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        collectionView = ArcanaHorizontalCollectionView(arcanaSection: arcanaSection, collectionViewLayout: layout)
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = dataSourceDelegate
        }
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(ArcanaIconCell.self, forCellWithReuseIdentifier: "ArcanaIconCell")
        
        addSubview(collectionView)
        
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
