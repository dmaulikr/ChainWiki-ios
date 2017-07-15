//
//  ArcanaSplitViewController.swift
//  Chain
//
//  Created by Jitae Kim on 6/18/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    var viewControllerList = [UIViewController]()
    
    init(arcanaVC: ArcanaVC) {
        super.init(nibName: nil, bundle: nil)
        setupControllers(arcanaVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = viewControllerList
        delegate = self
        view.backgroundColor = .gray
        maximumPrimaryColumnWidth = 300
        preferredDisplayMode = .allVisible
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    func setupControllers(_ arcanaVC: ArcanaVC) {
        
        let masterVC: ArcanaViewController
        let homeVC = HomeViewController()
        let welcomeVC = WelcomeViewController()
        
        switch arcanaVC {
            
        case .search:
            masterVC = SearchArcanaViewController()
            
        case .tavern:
            masterVC = SearchArcanaViewController()
            
        case .favorites:
            masterVC = FavoritesArcanaViewController()
            
        }
        
//        let masterVC = HomeViewController()
//        masterVC.welcomeDelegate = welcomeVC
        
//        viewControllerList = [NavigationController(masterVC), NavigationController(homeVC)]
        viewControllerList = [NavigationController(homeVC), NavigationController(welcomeVC)]
        
    }
    
}
