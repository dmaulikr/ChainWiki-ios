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
            
            switch index {
                case 1: // Ability Tab
                    let vc = CollectionViewWithMenu()
                    let child = UINavigationController(rootViewController: vc)
//                    child.navigationBar.isHidden = true
                    
                    child.tabBarItem.title = tab
                    child.tabBarItem.image = tabIcons[index]
                    child.tabBarItem.tag = index
                    views.append(child)
                
                case 2: // Tavern Tab
                    let vc = CollectionViewWithMenu(menuType: .TavernList)
                    let child = UINavigationController(rootViewController: vc)
//                    child.title = "주점"
//                    child.navigationBar.isHidden = true
                    
                    child.tabBarItem.title = tab
                    child.tabBarItem.image = tabIcons[index]
                    child.tabBarItem.tag = index
                    views.append(child)
                
                default:
                    let currentStoryboard = UIStoryboard(name: storyboards[index], bundle:nil)
                    let child = currentStoryboard.instantiateViewController(withIdentifier: childVCs[index]) as! UINavigationController
                    
                    child.tabBarItem.title = tab
                    child.tabBarItem.image = tabIcons[index]
                    child.tabBarItem.tag = index
                    views.append(child)


            }

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

        imageViews[item.tag].bounceAnimate()

        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()
        
    }

    
}

