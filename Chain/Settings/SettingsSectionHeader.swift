//
//  SettingsSectionHeader.swift
//  Chain
//
//  Created by Jitae Kim on 10/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SettingsSectionHeader: UIView {

    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = .black
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(sectionTitleLabel)
        
        sectionTitleLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        sectionTitleLabel.anchorCenterYToSuperview()
    }

}
