//
//  PageViewController.swift
//  
//
//  Created by Jitae Kim on 10/18/16.
//
//

import UIKit

class PageViewController: UIPageViewController {
    
    fileprivate let photos = [#imageLiteral(resourceName: "listPreview"), #imageLiteral(resourceName: "abilityPreview"), #imageLiteral(resourceName: "mainGridPreview")]
    fileprivate let descs = ["종류별로 아르카나 검색.", "어빌리티별로 아르카나 검색.", "맞춤형 설정"]
    fileprivate var currentIndex: Int!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Color.gray247
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func setupViewControllers() {
        
        let index = currentIndex ?? 0
        let page = TutorialViewController(index: index, photo: photos[index], desc: descs[index])
        
        let viewControllers = [page]
        
        setViewControllers(
            viewControllers,
            direction: .forward,
            animated: false,
            completion: nil
        )
    }

}

extension PageViewController: UIPageViewControllerDataSource {
    
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? TutorialViewController {
            var index = viewController.tutorialIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index - 1
            return TutorialViewController(index: index, photo: photos[index], desc: descs[index])
        }
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? TutorialViewController {
            
            let index = viewController.tutorialIndex
            let nextindex = index + 1
            
            if nextindex == photos.count {
                return nil
            }
            else {
                return TutorialViewController(index: nextindex, photo: photos[nextindex], desc: descs[nextindex])
            }
            
        }
        return nil
    }

}
