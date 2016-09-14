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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Ability", bundle:nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "AbilityNav") as! UINavigationController
        
        self.addChildViewController(vc)
        self.tabBar.tintColor = lightGreenColor
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if viewController == self.viewControllers![0] {
            print("home")
            
        }
        
        if viewController == self.viewControllers![1] {
            print("ability")
        }
    }
    
}
