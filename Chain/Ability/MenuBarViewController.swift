//
//  MenuBarViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class MenuBarViewController: UIViewController {

    var menuBar: MenuBar!
    var menuType: MenuType
    var numberOfMenuTabs: Int = 2
    var childViewController: BaseCollectionViewController?
    var selectedIndex: Int = 0
    var abilityType: (String, String)?
    var abilityMenu: AbilityMenu?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var previewButton: UIBarButtonItem = {
        
        let showAbilityPreview = defaults.getPreviewAbility()
        let previewIcon: UIImage
        
        if showAbilityPreview {
            previewIcon = #imageLiteral(resourceName: "collapse")
        }
        else {
            previewIcon = #imageLiteral(resourceName: "expand")
        }
        let button = UIBarButtonItem(image: previewIcon, style: .plain, target: self, action: #selector(toggleAbilityPreview))
        return button
    }()
    
    init(menuType: MenuType) {
        self.menuType = menuType
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(abilityType: (String, String), abilityMenu: AbilityMenu) {
        self.init(menuType: .abilityView)
        self.abilityType = abilityType
        self.abilityMenu = abilityMenu
        title = abilityType.0
        let backButton = UIBarButtonItem(title: "어빌", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupViews()
        setupChildViewController()
    }

    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white

        view.addSubview(menuBar)
        view.addSubview(containerView)
        
        menuBar.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 40)
        
        containerView.anchor(top: menuBar.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupMenuBar() {
        
        menuBar = MenuBar(menuType: menuType)

        menuBar.menuBarDelegate = self

        switch menuType {
        case .abilityList:
            numberOfMenuTabs = 2
            title = "어빌리티"
            Analytics.setScreenName("AbilityList", screenClass: nil)
        case .abilityView:
            numberOfMenuTabs = 5
            setupNavBar()
            Analytics.setScreenName("AbilityView", screenClass: nil)
        case .tavernList:
            numberOfMenuTabs = 3
            title = "주점"
            Analytics.setScreenName("TavernList", screenClass: nil)
        }
        
    }
    
    func setupChildViewController() {
        
        if menuType == .abilityView {
            guard let abilityType = abilityType, let abilityMenu = abilityMenu else { return }
            childViewController = BaseCollectionViewController(abilityType: abilityType, abilityMenu: abilityMenu)
        }
        else {
            childViewController = BaseCollectionViewController(menuType: menuType)
        }
        
        childViewController?.menuBarDelegate = self
        
        guard let childViewController = childViewController else { return }
        
        addChildViewController(childViewController)
        
        containerView.addSubview(childViewController.view)
        
        childViewController.view.frame = containerView.frame
        
//        childViewController.didMove(toParentViewController: self)

    }
    
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = previewButton
    }
    
    func toggleAbilityPreview() {
        
        guard let showAbilityPreview = childViewController?.showAbilityPreview else { return }
        
        if showAbilityPreview {
            previewButton.image = #imageLiteral(resourceName: "expand")
        }
        else {
            previewButton.image = #imageLiteral(resourceName: "collapse")
        }
        childViewController?.showAbilityPreview = !showAbilityPreview
        defaults.setPreviewAbility(value: !showAbilityPreview)
        
    }
    
}
