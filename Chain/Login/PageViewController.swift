//
//  PageViewController.swift
//  
//
//  Created by Jitae Kim on 10/18/16.
//
//

import UIKit

class PageViewController: UIPageViewController {
    let photos = [#imageLiteral(resourceName: "PreviewFilter"), #imageLiteral(resourceName: "PreviewAbility"), #imageLiteral(resourceName: "PreviewEdit")]
    let descs = ["종류별로 아르카나 검색.", "어빌리티별로 아르카나 검색.", "아르카나 정보 수정."]
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.gray247
        dataSource = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        if let viewController = viewTutorialController(index: currentIndex ?? 0) {
            let viewControllers = [viewController]

            setViewControllers(
                viewControllers,
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func viewTutorialController(index: Int) -> TutorialViewController? {
        if let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
                as? TutorialViewController {
            page.photo = photos[index]
            page.desc = descs[index]
            page.tutorialIndex = index
            return page
        }
        return nil
    }
}

//MARK: implementation of UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? TutorialViewController {
            var index = viewController.tutorialIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index! - 1
            return viewTutorialController(index: index!)
        }
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? TutorialViewController {
            
            if let index = viewController.tutorialIndex {
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
