//
//  ArcanaAttributeCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaAttributeCell: BaseTableViewCell {
    
    let attributeKeyLabel = ArcanaAttributeHeaderLabel()
    
    let attributeValueLabel: UILabel = {
        let label = UILabel()
        label.font = APPLEGOTHIC_17
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        
        addSubview(attributeKeyLabel)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        attributeKeyLabel.setContentHuggingPriority(.greatestFiniteMagnitude, for: .vertical)
        attributeValueLabel.anchor(top: attributeKeyLabel.bottomAnchor, leading: attributeKeyLabel.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
}

class ArcanaAttributeHeaderLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 17)
        textColor = Color.lightGreen
    }
    
}

class ArcanaAttributeDescLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        font = APPLEGOTHIC_17
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
    }
    
}
