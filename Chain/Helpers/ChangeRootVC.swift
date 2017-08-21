//
//  ChangeRootVC.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum RootVC {
        case home
        case login
        case logout
    }
    
    func changeRootVC(vc: RootVC) {
        
        guard let snapshot:UIView = view.window?.snapshotView(afterScreenUpdates: true) else { return }

        var initialViewController = UIViewController()
        
        switch vc {
            
        case .home:
            initialViewController = MyTabBarController()
        case .login:
            initialViewController = LoginHome()
        case .logout:
            initialViewController = PageViewController()
        
        }
        
        initialViewController.view.addSubview(snapshot)
        view.window?.rootViewController = initialViewController
        
        UIView.animate(withDuration: 0.2, animations: {()  in
            
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview()
            
        })

    }
    
}
