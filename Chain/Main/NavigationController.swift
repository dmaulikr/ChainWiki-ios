//
//  NavigationController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Hero

class NavigationController: UINavigationController {

    init(_ rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.addChildViewController(rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupviews()
    }
    
    func setupviews() {
        
        isHeroEnabled = true
        heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
            
        let fontSize: CGFloat
        if horizontalSize == .compact {
            fontSize = 17
        }
        else {
            fontSize = 20
        }
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)!]
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = Color.lightGreen
    }

}
