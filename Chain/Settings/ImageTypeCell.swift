//
//  ImageTypeCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ImageTypeCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        super.setupViews()

        tintColor = Color.lightGreen
        
        addSubview(titleLabel)
        
        titleLabel.anchorCenterSuperview()
    }
    
}

