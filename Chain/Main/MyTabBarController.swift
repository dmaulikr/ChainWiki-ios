//
//  MyTabBarController.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import UIKit
import Firebase

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private enum Tab: Int {
        case arcana
        case ability
        case tavern
        case dataLink
        case favorites
    }

    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
        tabBar.tintColor = Color.lightGreen
        
    }
    
    func setupTabBar() {
        
        let arcanaTab = NavigationController(rootViewController: SearchArcanaViewController())
        arcanaTab.tabBarItem = UITabBarItem(title: "아르카나", image: #imageLiteral(resourceName: "arcanaTab"), tag: 0)
        
        let abilityTab = NavigationController(rootViewController: MenuBarViewController(menuType: .abilityList))
        abilityTab.tabBarItem = UITabBarItem(title: "어빌리티", image: #imageLiteral(resourceName: "abilityTab"), tag: 1)
        
        let tavernTab = NavigationController(rootViewController: MenuBarViewController(menuType: .tavernList))
        tavernTab.tabBarItem = UITabBarItem(title: "주점", image: #imageLiteral(resourceName: "tavern"), tag: 2)
        
        let dataTab = NavigationController(rootViewController: DataViewController())
        dataTab.tabBarItem = UITabBarItem(title: "자료", image: #imageLiteral(resourceName: "openSite"), tag: 3)
        
        let favoritesTab = NavigationController(rootViewController: FavoritesArcanaViewController())
        favoritesTab.tabBarItem = UITabBarItem(title: "즐겨찾기", image: #imageLiteral(resourceName: "favorites"), tag: 4)
        
        viewControllers = [arcanaTab, abilityTab, tavernTab, dataTab, favoritesTab]
        
        // Setup to-be-animated views
        for childView in tabBar.subviews {
            
            let tabBarItemView = childView
            let tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            tabBarImageView.contentMode = .center
            imageViews.append(tabBarImageView)

        }

        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        imageViews[item.tag].bounceAnimate()

        var tabBarItem = ""
        
        guard let tab = Tab(rawValue: item.tag) else { return }
        
        switch tab {
        case .arcana:
            tabBarItem = "Arcana"
        case .ability:
            tabBarItem = "Ability"
        case .tavern:
            tabBarItem = "Tavern"
        case .dataLink:
            tabBarItem = "Data"
        case .favorites:
            tabBarItem = "Favorites"
            
        }
        
        FIRAnalytics.logEvent(withName: "SelectedTabBarItem", parameters: [
            "name" : tabBarItem as NSObject
            ])
        
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()
        
    }

    
}

