//
//  ArcanaPreviewTableViewCollectionViewCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/24/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewTableViewCollectionViewCell: UICollectionViewCell {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        tableView.tag = 2
        tableView.backgroundColor = .white
        tableView.alpha = 1
        tableView.estimatedRowHeight = 90
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(UINib(nibName: "ArcanaPreviewViewWrapperTableViewCell", bundle: nil), forCellReuseIdentifier: "ArcanaPreviewViewWrapperTableViewCell")
        tableView.register(UINib(nibName: "ArcanaFullViewWrapperTableViewCell", bundle: nil), forCellReuseIdentifier: "ArcanaFullViewWrapperTableViewCell")
        
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(tableView)
        tableView.anchorEdgesToSuperview()
        
    }
    
    func setupCollectionView<D: UITableViewDelegate & UITableViewDataSource>(_ dataSourceDelegate: D) {
        
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        
    }
}
