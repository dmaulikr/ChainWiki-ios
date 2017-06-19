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
    
    lazy var viewControllerList: [UIViewController] = {
        
        let searchArcanaVC = SearchArcanaViewController()
        let arcanaDetailVC = WelcomeViewController()
        
        let rootViewController = NavigationController(searchArcanaVC)
        let detailViewController = NavigationController(arcanaDetailVC)
        
        return [rootViewController, detailViewController]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = viewControllerList
        delegate = self
        view.backgroundColor = .white
        preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
        maximumPrimaryColumnWidth = 300
    }

}
