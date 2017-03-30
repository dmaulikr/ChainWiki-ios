//
//  ImageTypeCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileImageCell: BaseTableViewCell {
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(arcanaImageView)
        addSubview(titleLabel)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
        titleLabel.anchor(top: nil, leading: arcanaImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.anchorCenterYToSuperview()
    }
    
}

class MainImageCell: ProfileImageCell {
    
    override func setupViews() {
        
        addSubview(arcanaImageView)
        addSubview(titleLabel)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 80)
        
        titleLabel.anchor(top: nil, leading: arcanaImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.anchorCenterYToSuperview()
        
    }
}
