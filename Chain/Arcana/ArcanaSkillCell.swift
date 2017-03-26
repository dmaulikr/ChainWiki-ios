//
//  ArcanaSkillCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaSkillCell: BaseTableViewCell {
    
    let skillNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .white
        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    let skillNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .black
        return label
    }()
    
    let skillManaLabel: UILabel = {
        let label = UILabel()
        label.text = "마나"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .white
        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    let skillManaCostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .black
        return label
    }()
    
    override func setupViews() {
        
        addSubview(skillNumberLabel)
        addSubview(skillNameLabel)
        addSubview(skillManaLabel)
        addSubview(skillManaCostLabel)
        
        skillNumberLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 66, heightConstant: 40)
        skillNumberLabel.anchorCenterYToSuperview()
        
        skillNameLabel.anchor(top: topAnchor, leading: skillNumberLabel.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        skillManaLabel.anchor(top: topAnchor, leading: skillNameLabel.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 0)
        
        skillManaCostLabel.anchor(top: nil, leading: skillManaLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 11, heightConstant: 30)
        skillManaCostLabel.anchorCenterYToSuperview()
        
    }

}
