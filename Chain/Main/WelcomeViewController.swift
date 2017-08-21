//
//  WelcomeViewController.swift
//  Chain
//
//  Created by Jitae Kim on 6/18/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
//    let logoImage: WelcomeLogoView = {
//        let view = WelcomeLogoView()
//        view.backgroundColor = .white
//        return view
//    }()
    
    let animatedLogoView = AnimatedLogoView()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "왼쪽 메뉴에서 아르카나를 선택해 시작하세요!"
        label.font = APPLEGOTHIC_17
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(animatedLogoView)
        
        animatedLogoView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 200, heightConstant: 200)
        animatedLogoView.animate()
        
        view.addSubview(welcomeLabel)
        
//        view.addSubview(logoImage)
//
//        logoImage.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 200, heightConstant: 200)
//
        let stackView = UIStackView(arrangedSubviews: [animatedLogoView, welcomeLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        stackView.anchorCenterSuperview()
        
//
//        logoImage.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 200, heightConstant: 200)
//        logoImage.anchorCenterXToSuperview()
//
//        welcomeLabel.anchor(top: logoImage.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func stopAnimating() {
        animatedLogoView.reset()
    }
    
}
