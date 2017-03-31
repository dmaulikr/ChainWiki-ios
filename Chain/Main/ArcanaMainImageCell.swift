//
//  ArcanaMainImageCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaMainImageCell: ArcanaImageIDCell {
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    override func setupViews() {
        
        addSubview(arcanaImageView)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: SCREENWIDTH * 1.5)
    }

}

class ArcanaMainImageCollectionViewCell: ArcanaImageIDCell {
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(arcanaImageView)
        
        arcanaImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: (SCREENWIDTH / 2 - 15) * 1.5)
    }
    
}
