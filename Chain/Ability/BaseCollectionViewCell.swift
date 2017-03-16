//
//  BaseCollectionViewCell.swift
//  Chain
//
//  Created by Jitae Kim on 12/5/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    weak var collectionViewDelegate: BaseCollectionViewController?

    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.estimatedSectionHeaderHeight = 50
        
        return tableView
        
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "아르카나가 없어요:("
        label.textColor = Color.textGray
        label.textAlignment = .center
        label.alpha = 0
        return label
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
        addSubview(tipLabel)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        tipLabel.anchorCenterSuperview()
        
    }
    
}
