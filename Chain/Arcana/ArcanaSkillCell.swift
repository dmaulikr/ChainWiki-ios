//
//  ArcanaSkillCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaSkillCell: BaseTableViewCell {
    
    let skillNumberLabel = ArcanaAttributeHeaderLabel()
    
    let skillManaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15)
        return label
    }()
    
    let skillDescLabel: UILabel = {
        let label = UILabel()
        label.font = APPLEGOTHIC_17
        label.numberOfLines = 0
        return label
    }()

    override func setupViews() {
        
        addSubview(skillNumberLabel)
        addSubview(skillManaLabel)
        addSubview(skillDescLabel)
        
        skillNumberLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        skillManaLabel.anchor(top: nil, leading: skillNumberLabel.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        skillManaLabel.centerYAnchor.constraint(equalTo: skillNumberLabel.centerYAnchor).isActive = true
        
        skillDescLabel.anchor(top: skillNumberLabel.bottomAnchor, leading: skillNumberLabel.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)

    }
    
}
