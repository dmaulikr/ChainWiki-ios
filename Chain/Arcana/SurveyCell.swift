//
//  SurveyCell.swift
//  Chain
//
//  Created by Jitae Kim on 6/3/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import KRWordWrapLabel

class SurveyCell: BaseTableViewCell {

    let answerLabel = KRLabel()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(answerLabel)
        
        answerLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
    }

}
