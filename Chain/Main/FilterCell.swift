//
//  FilterCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    let filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Light", size: 12)
        label.textColor = Color.textGray
        return label
    }()
    
    func setupViews() {
        
        addSubview(filterLabel)
        
        filterLabel.anchorCenterSuperview()
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
