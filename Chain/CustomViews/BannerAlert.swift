//
//  BannerAlert.swift
//  Chain
//
//  Created by Jitae Kim on 12/6/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

enum BannerFormType {
    
    case emailNotFound
    case emailAlreadyInUse
    case invalidEmail
    
    case incorrectPassword
    case weakPassword
    case shortPassword

    case nicknameAlreadyInUse
    case shortNickname

    case serverError
    
    case noEdits
}

protocol DisplayBanner {
    func displayBanner(formType: BannerFormType, color: UIColor)
}

extension DisplayBanner where Self: UIViewController {
    
    func displayBanner(formType: BannerFormType, color: UIColor = Color.salmon) {
        let banner = BannerAlert(formType: formType, color: color)
        
        view.addSubview(banner)
        
        banner.alpha = 0
        banner.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            banner.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: {
            (Bool) -> Void in
            UIView.animate(withDuration: 0.2, delay: 3, options: .curveEaseOut, animations: {
                banner.alpha = 0
                
            }, completion: { finished in
                banner.removeFromSuperview()
                self.tabBarController?.tabBar.isHidden = false
            })
        })
        
        
    }
    
}

class BannerAlert: UIView {
    
    let formType: BannerFormType
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    init(formType: BannerFormType, color: UIColor) {
        self.formType = formType
        super.init(frame: .zero)
        backgroundColor = color
        setupViews()
        setLabelText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(textLabel)
        
        textLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)        
        
    }
    
    func setLabelText() {
        
        switch formType {
            
        case .emailNotFound:
            textLabel.text = "계정을 찾지 못하였습니다."
        case .emailAlreadyInUse:
            textLabel.text = "이메일이 이미 사용 중입니다."
        case .invalidEmail:
            textLabel.text = "이메일 형식이 맞지 않습니다."
        case .incorrectPassword:
            textLabel.text = "비밀번호가 틀렸습니다."
        case .weakPassword:
            textLabel.text = "비밀번호가 약합니다."
        case .shortPassword:
            textLabel.text = "비밀번호 6자 이상이 필요합니다."
        case .nicknameAlreadyInUse:
            textLabel.text = "닉네임이 이미 사용 중입니다."
        case .shortNickname:
            textLabel.text = "닉네임은 2자 이상이 필요합니다."
        case .serverError:
            textLabel.text = "서버에 접속하지 못하였습니다."
            
        case .noEdits:
            textLabel.text = "수정된 정보가 없었습니다."
        }
    }

    


}
