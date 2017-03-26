//
//  ArcanaAttributeCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaAttributeCell: BaseTableViewCell {

    let attributeKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .white
        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    let attributeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    override func setupViews() {

        addSubview(attributeKeyLabel)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 66, heightConstant: 0)
        attributeValueLabel.anchor(top: topAnchor, leading: attributeKeyLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
}
