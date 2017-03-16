//
//  MyTabBarController.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private enum Tab: Int {
        case arcana
        case ability
        case tavern
        case dataLink
        case favorites
    }

    let tabTitles = ["아르카나", "어빌리티", "주점", "자료", "즐겨찾기"]
    let tabIcons = [#imageLiteral(resourceName: "arcanaTab"), #imageLiteral(resourceName: "abilityTab"), #imageLiteral(resourceName: "tavern"), #imageLiteral(resourceName: "openSite"), #imageLiteral(resourceName: "favorites")]
    
    var tabBarImageView: UIImageView!
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBar()
        tabBar.tintColor = Color.lightGreen
        
    }
    
    func setupTabBar() {
        
        var views = [UIViewController]()
        
        for (index, title) in tabTitles.enumerated() {
            
            guard let tab = Tab(rawValue: index) else { return }
            
            switch tab {
              
            case .arcana:
                let vc = SearchArcanaViewController()
                let child = NavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)

            case .ability:
                let vc = MenuBarViewController(menuType: .abilityList)
                let child = NavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)

            case .tavern:
                let vc = MenuBarViewController(menuType: .tavernList)
                let child = NavigationController(rootViewController: vc)

                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
                
            case .dataLink:
                let vc = DataViewController()
                let child = NavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
                
            case .favorites:
                let vc = FavoritesArcanaViewController()
                let child = NavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
                
            default:
                let child = UIViewController()
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
            }

        }

        viewControllers = views
        
        // Setup to-be-animated views
        for childView in tabBar.subviews {
            
            let tabBarItemView = childView
            tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            tabBarImageView.contentMode = .center
            imageViews.append(tabBarImageView)

        }

        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        super.tabBar(tabBar, didSelect: item)
        imageViews[item.tag].bounceAnimate()

        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()
        
    }

    
}

