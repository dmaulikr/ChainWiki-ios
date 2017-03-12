//
//  ArcanaPeekTableViewHeader.swift
//  Chain
//
//  Created by Jitae Kim on 3/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPeekTableViewHeader: UIView {
    
    private let name: String
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = Color.lightGreen
//        label.backgroundColor = Color.lightGreen
        label.textAlignment = .center
        return label
    }()
    
    init(name: String) {
        self.name = name
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        nameLabel.text = name
        
        backgroundColor = .white
        
        addSubview(nameLabel)
        
        nameLabel.anchor(top: topAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 5, leadingConstant: 0, trailingConstant: 0, bottomConstant: 5, widthConstant: 0, heightConstant: 0)
        nameLabel.anchorCenterSuperview()
        
    }

}
