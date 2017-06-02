//
//  ArcanaAttributeCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaNameCell: BaseTableViewCell {
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let arcanaNameKR: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let arcanaNameJP: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override func setupViews() {
        
        addSubview(arcanaImageView)
        addSubview(arcanaNameKR)
        addSubview(arcanaNameJP)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 66, heightConstant: 66)
        
        let nameStackView = UIStackView(arrangedSubviews: [arcanaNameKR, arcanaNameJP])
        nameStackView.axis = .vertical
        nameStackView.alignment = .center
        nameStackView.spacing = 10
        nameStackView.distribution = .equalCentering
        
        addSubview(nameStackView)
        
        nameStackView.anchor(top: nil, leading: arcanaImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        nameStackView.anchorCenterYToSuperview()
        
//        arcanaNameKR.anchor(top: arcanaImageView.topAnchor, leading: arcanaImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//        
//        arcanaNameJP.anchor(top: nil, leading: arcanaNameKR.leadingAnchor, trailing: arcanaNameKR.trailingAnchor, bottom: arcanaImageView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
    }

}

class ArcanaAttributeCell: BaseTableViewCell {
    
    let attributeKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 17)
        label.textColor = Color.lightGreen
        return label
    }()
    
    let attributeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        
        addSubview(attributeKeyLabel)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        attributeValueLabel.anchor(top: attributeKeyLabel.bottomAnchor, leading: attributeKeyLabel.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
    }
    
}
class ArcanaAttributeCellOld: BaseTableViewCell {

    let attributeKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 17)
        label.textColor = Color.lightGreen
//        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
//        label.textColor = .white
//        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    let attributeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
//        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    override func setupViews() {

        addSubview(attributeKeyLabel)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 66, heightConstant: 0)
        attributeValueLabel.anchor(top: topAnchor, leading: attributeKeyLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)

        
    }
}
