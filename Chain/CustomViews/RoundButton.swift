//
//  RoundButton.swift
//  Chain
//
//  Created by Jitae Kim on 6/30/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        layer.cornerRadius = 5
    }
    
    
}
