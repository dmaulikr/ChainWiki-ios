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
    let arcanaVC: ArcanaVC
    
    init(arcanaVC: ArcanaVC) {
        self.arcanaVC = arcanaVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers(arcanaVC)
        viewControllers = viewControllerList
        delegate = self
        view.backgroundColor = .white
        maximumPrimaryColumnWidth = 300
        presentsWithGesture = false
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    func setupControllers(_ arcanaVC: ArcanaVC) {
        
        let masterVC: ArcanaViewController
        let detailVC: UIViewController
        
        switch arcanaVC {
            
        case .search:
            masterVC = SearchArcanaViewController()
            detailVC = HomeViewController()
            preferredDisplayMode = .primaryHidden
        case .tavern:
            masterVC = SearchArcanaViewController()
            detailVC = WelcomeViewController()
            masterVC.welcomeDelegate = detailVC as? WelcomeViewController
            preferredDisplayMode = .automatic
        case .favorites:
            masterVC = FavoritesArcanaViewController()
            detailVC = WelcomeViewController()
            masterVC.welcomeDelegate = detailVC as? WelcomeViewController
            preferredDisplayMode = .automatic
        }
        
//        let masterVC = HomeViewController()
//        masterVC.welcomeDelegate = welcomeVC
        
        viewControllerList = [NavigationController(masterVC), NavigationController(detailVC)]
//        viewControllerList = [NavigationController(homeVC), NavigationController(welcomeVC)]
        
    }
    
}
