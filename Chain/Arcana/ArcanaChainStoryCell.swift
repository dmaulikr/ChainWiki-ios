//
//  ArcanaChainStory.swift
//  Chain
//
//  Created by Jitae Kim on 9/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaChainStoryCell: BaseTableViewCell {

    let storyKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
//        label.textColor = .white
//        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    let storyAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
//        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    override func setupViews() {
        
        addSubview(storyKeyLabel)
        addSubview(storyAttributeLabel)
        
        storyKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 100, heightConstant: 0)
        storyKeyLabel.anchorCenterYToSuperview()
        
        storyAttributeLabel.anchor(top: topAnchor, leading: storyKeyLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}
