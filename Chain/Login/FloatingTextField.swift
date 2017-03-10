//
//  Floatingswift
//  Chain
//
//  Created by Jitae Kim on 3/10/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class FloatingTextField: SkyFloatingLabelTextFieldWithIcon {

    let placeHolderTitle: String
    
    init(title: String) {
        placeHolderTitle = title
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
//        iconWidth = 20
//        iconMarginBottom = 0
        backgroundColor = .clear
        tintColor = Color.lightGreen
        textColor = .black

        placeholder = placeHolderTitle
        placeholderColor = .lightGray

        lineColor = .lightGray
        selectedLineColor = Color.lightGreen

        selectedTitle = placeHolderTitle
        selectedTitleColor = Color.lightGreen
        
        selectedIconColor = Color.lightGreen
        iconFont = UIFont(name: "FontAwesome", size: 15)
        iconColor = Color.lightGray
        
        errorColor = Color.darkSalmon
        
        clearButtonMode = .whileEditing
        
        if title == "이메일" {
            iconText = "\u{f0e0}"
            keyboardType = .emailAddress
        }
        else if title == "비밀번호" {
            iconText = "\u{f023}"
            isSecureTextEntry = true
        }

    }

}
