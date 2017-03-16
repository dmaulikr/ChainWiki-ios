//
//  Floatingswift
//  Chain
//
//  Created by Jitae Kim on 3/10/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

enum TextFieldFormType {
    case email
    case password
    case passwordConfirm
    case nickname
}

class FloatingTextField: SkyFloatingLabelTextFieldWithIcon {

    let formType: TextFieldFormType
    
    init(_ form: TextFieldFormType) {
        formType = form
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

        backgroundColor = .clear
        tintColor = Color.lightGreen
        textColor = .black
        font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        
        placeholderColor = .lightGray
        placeholderFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)

        lineColor = .lightGray
        selectedLineColor = Color.lightGreen

        selectedTitleColor = Color.lightGreen
        
        selectedIconColor = Color.lightGreen
        iconFont = UIFont(name: "FontAwesome", size: 15)
        iconColor = Color.lightGray
        
        errorColor = Color.darkSalmon
        
        clearButtonMode = .whileEditing
        
        switch formType {
            
        case .email:
            placeholder = "이메일"
            selectedTitle = "이메일"
            iconText = "\u{f0e0}"
            keyboardType = .emailAddress
            
        case .password, .passwordConfirm:
            placeholder = "비밀번호"
            selectedTitle = "비밀번호"
            iconText = "\u{f023}"
            isSecureTextEntry = true

        case.nickname:
            placeholder = "닉네임"
            selectedTitle = "닉네임"
            iconText = "\u{f007}"
            tag = 3
        }

        autocapitalizationType = .none
    }

}
