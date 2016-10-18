//
//  PageViewController.swift
//  
//
//  Created by Jitae Kim on 10/18/16.
//
//

import UIKit

class PageViewController: UIPageViewController {
    let photos = [#imageLiteral(resourceName: "HomeView"), #imageLiteral(resourceName: "TavernView"), #imageLiteral(resourceName: "AbilityView")]
    let descs = ["종류별로 아르카나를 검색", "주점 가챠 목록도 볼 수 있습니다.", "어빌리티별로 아르카나 검색도 가능합니다.", "아르카나 정보를 수정할 수 있습니다."]
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        dataSource = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        setupPageController()
        // 1
        if let viewController = viewTutorialController(index: currentIndex ?? 0) {
            let viewControllers = [viewController]
            // 2
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
                    // out of boudns
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
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return photos.count
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentIndex ?? 0
//    }

}
