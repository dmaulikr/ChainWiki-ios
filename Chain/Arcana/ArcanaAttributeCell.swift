//
//  ArcanaAttributeCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaNameCell: UICollectionViewCell {
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(arcanaImageView)
        addSubview(arcanaNameKR)
        addSubview(arcanaNameJP)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 70, heightConstant: 70)
        
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

class ArcanaBaseInfoCell: UICollectionViewCell {
    
    let attributeKeyLabel = ArcanaAttributeHeaderLabel()
    
    let attributeValueLabel = ArcanaAttributeDescLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(attributeKeyLabel)
        addSubview(attributeValueLabel)
        
        attributeKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        attributeKeyLabel.setContentHuggingPriority(.greatestFiniteMagnitude, for: .vertical)
        
        attributeValueLabel.anchor(top: attributeKeyLabel.bottomAnchor, leading: attributeKeyLabel.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 30)
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
        attributeKeyLabel.setContentHuggingPriority(.greatestFiniteMagnitude, for: .vertical)
        arcanaClassImageView.anchor(top: nil, leading: attributeKeyLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 20)
        arcanaClassImageView.centerYAnchor.constraint(equalTo: attributeValueLabel.centerYAnchor).isActive = true
        
        attributeValueLabel.anchor(top: attributeKeyLabel.bottomAnchor, leading: arcanaClassImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 30)
        
    }
    
}

class ArcanaAttributeHeaderLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        font = APPLEGOTHIC_17
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
    }
    
}
