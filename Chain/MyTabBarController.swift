//
//  MyTabBarController.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import UIKit
import RAMAnimatedTabBarController

class MyTabBarController: RAMAnimatedTabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        self.delegate = self
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let abilityStoryboard : UIStoryboard = UIStoryboard(name: "Ability", bundle:nil)
        let tavernStoryboard : UIStoryboard = UIStoryboard(name: "Tavern", bundle:nil)
//        let settingsStoryboard : UIStoryboard = UIStoryboard(name: "Settings", bundle:nil)
        
        let ability = abilityStoryboard.instantiateViewController(withIdentifier: "AbilityNav") as! UINavigationController
        let tavern = tavernStoryboard.instantiateViewController(withIdentifier: "TavernNav") as! UINavigationController
        let favorites = mainStoryboard.instantiateViewController(withIdentifier: "FavoritesNav") as! UINavigationController
//        let settings = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController

    
        self.addChildViewController(ability)
        self.addChildViewController(tavern)
        self.addChildViewController(favorites)
//        self.addChildViewController(settings)
        
        self.tabBar.tintColor = Color.lightGreen
        
        let abilityTabItem = RAMAnimatedTabBarItem(
            title: "어빌리티",
            image: #imageLiteral(resourceName: "abilityTab"),
            selectedImage: #imageLiteral(resourceName: "abilityTab")
        )
        abilityTabItem.animation = RAMBounceAnimation()
        ability.tabBarItem = abilityTabItem
        

        
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()

    }

    
}


