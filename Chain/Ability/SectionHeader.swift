//
//  ProfileSectionHeader.swift
//  dtto
//
//  Created by Jitae Kim on 1/3/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SectionHeader: UIView {

    let sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.lightGreen
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.alpha = 1
        return label
    }()
    
    var underline = HorizontalBar()
    
    init(sectionTitle: String) {
        super.init(frame: .zero)
        self.sectionLabel.text = sectionTitle
        setupViews()
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(sectionLabel)
        addSubview(underline)
        
        sectionLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 5, leadingConstant: 10, trailingConstant: 0, bottomConstant: 5, widthConstant: 0, heightConstant: 0)

        underline.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setText(text: String) {
        UIView.animate(withDuration: 0.2) {
            self.sectionLabel.text = text
        }
//        if sectionLabel.alpha == 0 {
//            sectionLabel.fadeIn(withDuration: 0.2)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
