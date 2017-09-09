//
//  ArcanaGridCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaIconCell: UICollectionViewCell {
    
    var arcanaID: String!
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.gray247
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /**
     Separate placeholder imageview because placeholder should be its original, smaller size
     ArcanaImageView is scaled to fill the whole cell
     **/
    let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icoTab1")
        imageView.tintColor = Color.lightGreen
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
        
        addSubview(arcanaImageView)
        addSubview(placeholderImageView)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        placeholderImageView.anchorCenterSuperview()
    }

}
