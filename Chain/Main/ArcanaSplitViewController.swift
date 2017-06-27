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
    
//    lazy var viewControllerList: [UIViewController] = {
//
//        let searchArcanaVC = SearchArcanaViewController()
//        let arcanaDetailVC = WelcomeViewController()
//
//        let rootViewController = NavigationController(searchArcanaVC)
//        let detailViewController = NavigationController(arcanaDetailVC)
//
//        return [rootViewController, detailViewController]
//
//    }()
    
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
        preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        maximumPrimaryColumnWidth = 300
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.width < UIScreen.main.bounds.width {
            maximumPrimaryColumnWidth = 300
        }
        else {
            maximumPrimaryColumnWidth = 600
        }
    }
    
    func setupControllers(_ arcanaVC: ArcanaVC) {
        
        let masterVC: ArcanaViewController
        let welcomeVC = WelcomeViewController()
        
        switch arcanaVC {
            
        case .search:
            masterVC = SearchArcanaViewController()
            
        case .tavern:
            masterVC = SearchArcanaViewController()
            
        case .favorites:
            masterVC = FavoritesArcanaViewController()
            
        }
        
        viewControllerList = [NavigationController(masterVC), welcomeVC]
        
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
