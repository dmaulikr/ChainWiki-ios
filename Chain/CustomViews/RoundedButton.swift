//
//  RoundedButton.swift
//  Chain
//
//  Created by Jitae Kim on 9/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor

    }

}
