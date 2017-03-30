//
//  ArcanaViewPageController.swift
//  Chain
//
//  Created by Jitae Kim on 3/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaViewPageController: UIPageViewController {
    
    fileprivate enum CurrentPage {
        case arcana
        case filter
    }
    
    fileprivate var currentPage: CurrentPage = .arcana
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewControllers()
        dataSource = self
    }

    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Color.gray247
        
        for view in view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
    }
    
    func setupViewControllers() {
        
//        let viewControllers = [NavigationController(rootViewController: SearchArcanaViewController())]
        let viewControllers = [NavigationController(rootViewController: SearchArcanaViewController())]
        setViewControllers(
            viewControllers,
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
}

extension ArcanaViewPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let _ = viewController as? UINavigationController {
            return nil
        }
        else {
//            currentPage = .arcana
            if let arcanaViewController = childViewControllers[0] as? NavigationController {
                return arcanaViewController
            }
            else {
                return NavigationController(rootViewController: SearchArcanaViewController())
            }

        }

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let _ = viewController as? UINavigationController {
//            currentPage = .filter
            if childViewControllers.count < 2 {
                let filterVC = FilterViewController()
                if let arcanaVC = (childViewControllers[0] as? NavigationController)?.childViewControllers[0] as? SearchArcanaViewController {
                    filterVC.delegate = arcanaVC
                    return filterVC
                }
            }
            else {
                if let filter = childViewControllers[1] as? FilterViewController {
                    return filter
                }
            }
        }
        else {
            return nil
        }
        
        return nil

    }
    
}

extension ArcanaViewPageController: UIScrollViewDelegate {
    
}
