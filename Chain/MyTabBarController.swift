//
//  MyTabBarController.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let tabTitles = ["아르카나", "어빌리티", "주점", "즐겨찾기"]
    let tabIcons = [#imageLiteral(resourceName: "arcanaTab"), #imageLiteral(resourceName: "abilityTab"), #imageLiteral(resourceName: "tavern"), #imageLiteral(resourceName: "favorites")]
    let storyboards = ["Main", "Ability", "Tavern", "Settings"]
    let childVCs = ["HomeNav", "AbilityNav", "TavernNav", "FavoritesNav"]
    
    var tabBarImageView: UIImageView!
    var imageViews = [UIImageView]()
    override func viewDidLoad() {
        
        self.delegate = self
        setupTabBar()
        self.tabBar.tintColor = Color.lightGreen
        
    }
    
    func setupTabBar() {
        
        var views = [UIViewController]()
        // Setup Tab Bar Views
        for (index, tab) in tabTitles.enumerated() {
            let currentStoryboard = UIStoryboard(name: storyboards[index], bundle:nil)
            let child = currentStoryboard.instantiateViewController(withIdentifier: childVCs[index]) as! UINavigationController
            child.tabBarItem.title = tab
            child.tabBarItem.image = tabIcons[index]
            child.tabBarItem.tag = index
            views.append(child)

        }

        self.viewControllers = views
        
        // Setup to-be-animated views
        for childView in tabBar.subviews {
            
            let tabBarItemView = childView
            self.tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            self.tabBarImageView.contentMode = .center
            imageViews.append(tabBarImageView)

        }

        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        imageViews[item.tag].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.imageViews[item.tag].transform = .identity
            },
                       completion: nil)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()
        
    }

    
}

