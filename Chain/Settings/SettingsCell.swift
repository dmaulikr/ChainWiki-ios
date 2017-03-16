//
//  SettingsCell.swift
//  Chain
//
//  Created by Jitae Kim on 10/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
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
        
        addSubview(icon)
        addSubview(titleLabel)
        
        icon.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 30, heightConstant: 30)
        titleLabel.anchor(top: topAnchor, leading: icon.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
                
    }

    
}
