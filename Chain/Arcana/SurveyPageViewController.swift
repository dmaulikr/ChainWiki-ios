//
//  SurveyPageViewController.swift
//  Chain
//
//  Created by Jitae Kim on 6/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAnalytics

fileprivate let descs = ["스크롤하면서 내비게이션 바(상단 메뉴바)와 탭바(하단 메뉴바)가 없어지는 게 어떤가요?", "2번째", "기타 의견"]

class SurveyPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    fileprivate var currentIndex: Int!
    var userAnswers = [String: String]()
    
    lazy var viewControllerList: [UIViewController] = {
        
        let firstVC = SurveyViewController(index: 0, desc: descs[0])
        firstVC.pageViewDelegate = self
        
        let secondVC = SurveyViewController(index: 1, desc: descs[1])
        secondVC.pageViewDelegate = self
        
        let thirdVC = SurveyViewController(index: 2, desc: descs[2])
        thirdVC.pageViewDelegate = self
        
        return [firstVC, secondVC, thirdVC]
        
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        return button
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
        setupNavBar()
        setupViewControllers()
        dataSource = self
        
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = cancelButton
    }

    func setupViewControllers() {
        
        if let firstVC = viewControllerList.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
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
    
    @objc func cancel() {
        dismiss(animated: true, completion: {
            // some analytics
            Analytics.logEvent("Survey cancelled", parameters: nil)
        })
    }
}

