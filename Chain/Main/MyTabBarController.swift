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
        case Arcana
        case Ability
        case Tavern
        case DataLink
        case Favorites
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
        // Setup Tab Bar Views
        
        for (index, title) in tabTitles.enumerated() {
            
            guard let tab = Tab(rawValue: index) else { return }
            
            switch tab {
              
            case .Arcana:
                let vc = Home()
                let child = UINavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)

            case .Ability:
                let vc = CollectionViewWithMenu()
                let child = UINavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
            
            case .Tavern:
                let vc = CollectionViewWithMenu(menuType: .tavernList)
                let child = UINavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
                
            case .DataLink:
                let vc = DataViewController()
                let child = UINavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
                
            case .Favorites:
                let vc = Favorites()
                let child = UINavigationController(rootViewController: vc)
                
                child.tabBarItem.title = title
                child.tabBarItem.image = tabIcons[index]
                child.tabBarItem.tag = index
                views.append(child)
                
//            default:
//                let child = UIViewController()
//                
//                child.tabBarItem.title = title
//                child.tabBarItem.image = tabIcons[index]
//                child.tabBarItem.tag = index
//                views.append(child)
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

