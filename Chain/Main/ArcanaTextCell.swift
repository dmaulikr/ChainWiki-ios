//
//  ArcanaTextCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaTextCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        label.textColor = Color.textGray
        return label
    }()
    
//    let nameJP: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
//        label.textColor = Color.textGray
//        return label
//    }()
    
    func setupViews() {
        
        addSubview(nameLabel)
        
        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 5, leadingConstant: 10, trailingConstant: 10, bottomConstant: 5, widthConstant: 0, heightConstant: 0)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
