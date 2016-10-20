//
//  ChangeRootVC.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    
    enum RootVC {
        case login
        case logout
    }
    
    func changeRootVC(vc: RootVC) {
        
        if vc == RootVC.login {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController")
            UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                self.window!.rootViewController = initialViewController
                }, completion: nil)
        }
        else {
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
            UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                self.window!.rootViewController = initialViewController
                }, completion: nil)

        }
        
    }
    
}
