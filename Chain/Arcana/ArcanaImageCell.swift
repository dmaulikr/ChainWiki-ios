//
//  ArcanaImageCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ArcanaImageCell: BaseTableViewCell {

    var imageLoaded = false
    
    let arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func setupViews() {
      
        addSubview(arcanaImageView)

        arcanaImageView.anchor(top: topAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 290, heightConstant: 400)
        arcanaImageView.anchorCenterXToSuperview()
    }
    
}
