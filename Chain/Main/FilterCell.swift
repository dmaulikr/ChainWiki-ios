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
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        label.textColor = Color.textGray
        label.highlightedTextColor = .white
        return label
    }()
    
    func setupViews() {
        
        backgroundColor = .white

        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.lightGreen
        selectedBackgroundView = backgroundView

        layer.cornerRadius = 3
        addSubview(filterLabel)
        
        filterLabel.anchorCenterSuperview()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
