//
//  SearchArcanaPageViewController.swift
//  Chain
//
//  Created by Jitae Kim on 4/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SearchArcanaPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var viewControllerList: [UIViewController] = {
        
        let searchVC = SearchArcanaViewController()
        let filterVC = FilterViewController()
        filterVC.delegate = searchVC
        
        return [NavigationController(searchVC), filterVC]
    }()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dataSource = self
        if let firstVC = viewControllerList.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0, viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex, viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]

    }

}
