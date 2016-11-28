//
//  AbilityListPageView.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListPageView: UIPageViewController {
    let photos = [0,1]
    let descs = ["종류별로 아르카나 검색.", "어빌리티별로 아르카나 검색.", "아르카나 정보 수정."]
    var currentIndex: Int!
    
    func setupPage() {
        
        self.title = "어빌리티"
        self.view.backgroundColor = .white

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        
        dataSource = self
        
        if let viewController = viewTutorialController(index: currentIndex ?? 0) {
            let viewControllers = [viewController]
            print(index)
            setViewControllers(
                viewControllers,
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
    }
    
    func viewTutorialController(index: Int) -> AbilityListTableView? {
        
        let storyboard = UIStoryboard(name: "Ability", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "AbilityListTableView") as? AbilityListTableView else { return nil }
        
       
        page.pageIndex = index
        return page
        
    }
}

//MARK: implementation of UIPageViewControllerDataSource
extension AbilityListPageView: UIPageViewControllerDataSource {
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? AbilityListTableView {
            var index = viewController.pageIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index! - 1
            return viewTutorialController(index: index!)
        }
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? AbilityListTableView {
            
            if let index = viewController.pageIndex {
                if index + 1 == photos.count {
                    // out of bounds
                    return nil
                }
                else {
                    return viewTutorialController(index: index + 1)
                }
            }
            else {
                return nil
            }
            
        }
        return nil
    }
    
}

