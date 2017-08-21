//
//  LinkCell.swift
//  Chain
//
//  Created by Jitae Kim on 4/3/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class DataCell: BaseTableViewCell {

    let linkTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        return label
    }()
    
    var badge: MIBadgeButton = {
        let badge = MIBadgeButton()
        badge.badgeString = "!"
        badge.badgeBackgroundColor = Color.lightGreen
        badge.alpha = 0
        return badge
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(linkTitleLabel)
        addSubview(badge)
        
        linkTitleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        badge.anchor(top: nil, leading: linkTitleLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 30, heightConstant: 30)
    }

}
