//
//  BaseCollectionViewCell.swift
//  Chain
//
//  Created by Jitae Kim on 12/5/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var tableDelegate: CollectionViewWithMenu?
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.estimatedSectionHeaderHeight = 50
        
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
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
}
