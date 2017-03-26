//
//  ArcanaSkillAbilityDescCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/31/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaSkillAbilityDescCell: BaseTableViewCell {
    
    let skillAbilityDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        
        addSubview(skillAbilityDescLabel)
        
        skillAbilityDescLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
    }



}
