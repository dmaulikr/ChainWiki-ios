//
//  ArcanaIconLabelCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaIconLabelCell: ArcanaIconCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    override func setupViews() {
        
        backgroundColor = .white
        
        addSubview(arcanaImageView)
        addSubview(nameLabel)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        nameLabel.anchor(top: arcanaImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 5, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 15)
        
    }
}
