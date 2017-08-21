//
//  ImageToggleCell.swift
//  Chain
//
//  Created by Jitae Kim on 3/15/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ImageToggleCell: SettingsCell {

    lazy var imageToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = Color.lightGreen
        toggle.addTarget(self, action: #selector(toggleImage), for: .valueChanged)
        return toggle
    }()
    
    @objc func toggleImage() {
        
        if defaults.getImagePermissions() {
            defaults.setImagePermissions(value: false)
        }
        else {
            defaults.setImagePermissions(value: true)
        }
        
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageToggle)

        imageToggle.anchor(top: nil, leading: titleLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        imageToggle.anchorCenterYToSuperview()

    }

}
