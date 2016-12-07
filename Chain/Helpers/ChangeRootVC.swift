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
        
        switch vc {
        case .home:
            let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true))!
            let initialViewController = MyTabBarController()
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
                
            })

        case .login:
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginForm")
            
            let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true))!
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
                
            })

        case .logout:
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
            
            let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true))!
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
                
            })

            
        }

    }
    
}
