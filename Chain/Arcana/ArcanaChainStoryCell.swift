//
//  ArcanaChainStory.swift
//  Chain
//
//  Created by Jitae Kim on 9/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaChainStoryCell: UITableViewCell {

    let storyKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .white
        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    let storyAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(storyKeyLabel)
        addSubview(storyAttributeLabel)
        
        storyKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 40)
        storyKeyLabel.anchorCenterYToSuperview()
        
        storyAttributeLabel.anchor(top: topAnchor, leading: storyKeyLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}
