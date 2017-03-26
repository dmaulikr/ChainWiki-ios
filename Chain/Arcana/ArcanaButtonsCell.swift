//
//  ArcanaButtonsCell.swift
//  Chain
//
//  Created by Jitae Kim on 10/10/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaButtonsCell: BaseTableViewCell {
    
    weak var arcanaDetailDelegate: ArcanaDetail?
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(_: #imageLiteral(resourceName: "heartNormal").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(_: #imageLiteral(resourceName: "heartSelected").withRenderingMode(.alwaysOriginal), for: .selected)
        button.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)
        return button
        
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(_: #imageLiteral(resourceName: "starNormal").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(_: #imageLiteral(resourceName: "starSelected").withRenderingMode(.alwaysOriginal), for: .selected)
        button.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)
        return button
        
    }()
    
    let numberOfLikesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        label.textColor = .lightGray
        return label
    }()
    
    override func setupViews() {
        
        addSubview(heartButton)
        addSubview(numberOfLikesLabel)
        addSubview(favoriteButton)
        
        heartButton.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 44, heightConstant: 44)
        heartButton.anchorCenterYToSuperview()
        
        numberOfLikesLabel.anchor(top: nil, leading: heartButton.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        numberOfLikesLabel.anchorCenterYToSuperview()
        
        favoriteButton.anchor(top: nil, leading: numberOfLikesLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 5, bottomConstant: 0, widthConstant: 44, heightConstant: 44)
        favoriteButton.anchorCenterYToSuperview()
        
    }
    
    func toggleButton(_ sender: UIButton) {
        
        if !sender.isSelected {
            sender.bounceAnimate()
        }
        sender.isSelected = !sender.isSelected
        
        if sender == heartButton {
            arcanaDetailDelegate?.toggleHeart(self)
        }
        else {
            arcanaDetailDelegate?.toggleFavorite(self)
        }
        
    }
    
    func toggleHeart(_ sender: UIButton!) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
            sender.bounceAnimate()
        }
    }
    
    func toggleFavorite(_ sender: UIButton!) {
        if (sender.isSelected) {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
            sender.bounceAnimate()
        }
    }

}
