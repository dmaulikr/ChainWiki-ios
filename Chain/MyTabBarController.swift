//
//  MyTabBarController.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
        self.tabBar.tintColor = lightGreenColor
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transitionFromView(fromView, toView: toView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        
        if viewController == self.viewControllers![0] {
            print("home")
            
        }
        
        if viewController == self.viewControllers![1] {
            print("tavern")
        }
    }
    
}
