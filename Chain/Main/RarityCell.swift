//
//  RarityCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/7/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RarityCell: UICollectionViewCell {
   
    let rarityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        label.textColor = Color.textGray
        label.highlightedTextColor = .white
        return label
    }()
    
    let rarityIcon: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "starGray"))
        imageView.contentMode = .scaleToFill
        imageView.highlightedImage = #imageLiteral(resourceName: "starWhite")
        return imageView
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.lightGreen
        selectedBackgroundView = backgroundView
        
        let stackView = UIStackView(arrangedSubviews: [rarityIcon, rarityLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        
        addSubview(stackView)
        
        stackView.anchorCenterSuperview()
        
    }
    
}
