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
        preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
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
        
        masterVC.welcomeDelegate = welcomeVC
        
        viewControllerList = [NavigationController(masterVC), NavigationController(welcomeVC)]
        
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        // reload tableview
        guard viewControllers.count >= 2 else { return }
        
        guard let arcanaNavVC = viewControllers[1] as? NavigationController else { return }
        if let arcanaVC = arcanaNavVC.topViewController as? ArcanaDetail {
            arcanaVC.tableView.setNeedsLayout()
        }
        
    }
}
