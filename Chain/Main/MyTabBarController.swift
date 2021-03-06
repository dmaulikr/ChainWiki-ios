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
        case ability
        case tavern
        case dataLink
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

    }
    
    func setupTabBar() {
        
//        let arcanaTab = NavigationController(HomeViewController())
        let arcanaTab = ArcanaSplitViewController(arcanaVC: .search)
        arcanaTab.tabBarItem = UITabBarItem(title: "아르카나", image: #imageLiteral(resourceName: "arcanaTab"), tag: 0)
        
        let abilityTab = NavigationController(MenuBarViewController(menuType: .abilityList))
        abilityTab.tabBarItem = UITabBarItem(title: "어빌리티", image: #imageLiteral(resourceName: "abilityTab"), tag: 1)
        
        let tavernTab = NavigationController(MenuBarViewController(menuType: .tavernList))
        tavernTab.tabBarItem = UITabBarItem(title: "주점", image: #imageLiteral(resourceName: "tavern"), tag: 2)
        
        let dataTab = NavigationController(DataViewController())
        dataTab.tabBarItem = UITabBarItem(title: "자료", image: #imageLiteral(resourceName: "openSite"), tag: 3)
        
//        let favoritesTab = NavigationController(FavoritesArcanaViewController())
        let favoritesTab = ArcanaSplitViewController(arcanaVC: .favorites)
        favoritesTab.tabBarItem = UITabBarItem(title: "즐겨찾기", image: #imageLiteral(resourceName: "favorites"), tag: 4)
        
        viewControllers = [arcanaTab, abilityTab, tavernTab, dataTab, favoritesTab]
        
        // Setup to-be-animated views
        for (index, childView) in tabBar.subviews.enumerated() {
            
            let tabBarItemView = childView
            let tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            if index == 3 {
                
                let dataRef = FIREBASE_REF.child("links").child("eventMission").child("url")
                dataRef.observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let currentMission = snapshot.value as? String else { return }
                    if let lastMission = defaults.getLastLink() {
                        
                        if currentMission != lastMission {
                            // show the badge.
                            defaults.setLastLink(value: currentMission)
                            self.badge = MIBadgeButton()
                            guard let badge = self.badge else { return }
                            badge.badgeBackgroundColor = Color.lightGreen
                            badge.badgeString = "!"
                            tabBarImageView.addSubview(badge)
                            badge.anchor(top: tabBarImageView.topAnchor, leading: nil, trailing: tabBarImageView.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 5, heightConstant: 5)
                        }

                        
                    }
                    else {
                        // first time setting up
                        defaults.setLastLink(value: currentMission)
                    }
                    
                })
                
            }
            tabBarImageView.contentMode = .center
            imageViews.append(tabBarImageView)

        }

        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        imageViews[item.tag].bounceAnimate()
        
        guard let tab = Tab(rawValue: item.tag) else { return }
        
        switch tab {
            
        case .dataLink:
            // get rid of badge if it has it
            badge?.removeFromSuperview()
        default:
            break
            
        }
        
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()
        
    }

    
}

