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
    
    var collectionViewOffset: CGFloat {
        get {
            print(collectionView.contentOffset.x)
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, arcanaSection: ArcanaSection) {
        
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.scrollDirection = .horizontal
            
            collectionView = ArcanaHorizontalCollectionView(arcanaSection: arcanaSection, collectionViewLayout: layout)
            
            collectionView.delegate = dataSourceDelegate
            collectionView.dataSource = dataSourceDelegate
            
            collectionView.isScrollEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .white
            
            collectionView.register(ArcanaIconCell.self, forCellWithReuseIdentifier: "ArcanaIconCell")
            
            addSubview(collectionView)
            
            collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
    }
    
}
