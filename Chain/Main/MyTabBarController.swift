//
//  MyTabBarController.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import UIKit
import Firebase
import MIBadgeButton_Swift

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private enum Tab: Int {
        case arcana
        case recent
        case ability
        case tavern
        case favorites
    }

    var imageViews = [UIImageView]()
    var badge: MIBadgeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
        tabBar.tintColor = Color.lightGreen
        tabBar.barTintColor = .white
        tabBar.isTranslucent = true
    }
    
    func setupTabBar() {
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "아르카나", image: #imageLiteral(resourceName: "arcanaTab"), tag: 0)

        let recentTab = ArcanaSplitViewController(arcanaVC: .search)
        recentTab.tabBarItem = UITabBarItem(title: "최신", image: #imageLiteral(resourceName: "list"), tag: 1)
        
        let abilityTab = NavigationController(MenuBarViewController(menuType: .abilityList))
        abilityTab.tabBarItem = UITabBarItem(title: "어빌리티", image: #imageLiteral(resourceName: "abilityTab"), tag: 2)
        
        let tavernTab = NavigationController(MenuBarViewController(menuType: .tavernList))
        tavernTab.tabBarItem = UITabBarItem(title: "주점", image: #imageLiteral(resourceName: "tavern"), tag: 3)
        
//        let dataTab = NavigationController(DataViewController())
//        dataTab.tabBarItem = UITabBarItem(title: "자료", image: #imageLiteral(resourceName: "openSite"), tag: 3)
        
//        let favoritesTab = NavigationController(FavoritesArcanaViewController())
        let favoritesTab = ArcanaSplitViewController(arcanaVC: .favorites)
        favoritesTab.tabBarItem = UITabBarItem(title: "즐겨찾기", image: #imageLiteral(resourceName: "favorites"), tag: 4)
        
        viewControllers = [homeTab, recentTab, abilityTab, tavernTab, favoritesTab]
        
        // Setup to-be-animated views
        for (_, childView) in tabBar.subviews.enumerated() {
            
            let tabBarItemView = childView
            let tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            tabBarImageView.contentMode = .center
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

