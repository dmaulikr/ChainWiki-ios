//
//  WelcomeViewController.swift
//  Chain
//
//  Created by Jitae Kim on 6/18/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "왼쪽 메뉴에서 아르카나를 선택해 시작하세요!"
        label.font = APPLEGOTHIC_17
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchorCenterSuperview()
    }
    
}
