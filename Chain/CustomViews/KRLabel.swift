//
//  KRLabel.swift
//  Chain
//
//  Created by Jitae Kim on 6/3/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import KRWordWrapLabel

class KRLabel: KRWordWrapLabel {

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        font = APPLEGOTHIC_17
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }

}
