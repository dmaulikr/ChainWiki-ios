//
//  ArcanaClassCell.swift
//  Chain
//
//  Created by Jitae Kim on 6/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaClassCell: ArcanaAttributeCell {

    let arcanaClassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(attributeKeyLabel)
        addSubview(arcanaClassImageView)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        arcanaClassImageView.anchor(top: attributeKeyLabel.bottomAnchor, leading: attributeKeyLabel.leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 25, heightConstant: 25)
        
        attributeValueLabel.anchor(top: attributeKeyLabel.bottomAnchor, leading: arcanaClassImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}

class ArcanaClassBaseInfoCell: ArcanaBaseInfoCell {
    
    let arcanaClassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        
        backgroundColor = .white
        
        addSubview(attributeKeyLabel)
        addSubview(arcanaClassImageView)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        arcanaClassImageView.anchor(top: attributeKeyLabel.bottomAnchor, leading: attributeKeyLabel.leadingAnchor, trailing: nil, bottom: attributeValueLabel.bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 20)
        
        attributeValueLabel.anchor(top: attributeKeyLabel.bottomAnchor, leading: arcanaClassImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
}
