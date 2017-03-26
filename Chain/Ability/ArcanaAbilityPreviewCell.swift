//
//  ArcanaAbilityPreviewCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaAbilityPreviewCell: BaseTableViewCell {

    let abilityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        
        addSubview(abilityLabel)
        
        abilityLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 5, leadingConstant: 10, trailingConstant: 10, bottomConstant: 5, widthConstant: 0, heightConstant: 0)
        
    }
    
}
