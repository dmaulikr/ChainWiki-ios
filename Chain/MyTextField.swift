//
//  MyTextField.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MyTextField: SkyFloatingLabelTextFieldWithIcon {

    override func layoutSubviews() {
        self.selectedLineColor = lightGreenColor
        self.selectedLineColor = lightGreenColor
        self.selectedIconColor = lightGreenColor
        self.tintColor = lightGreenColor
        self.clearButtonMode = .whileEditing
        self.iconFont = UIFont(name: "FontAwesome", size: 15)
        self.iconColor = lightGrayColor
        self.errorColor = darkSalmonColor
    }

    
}
