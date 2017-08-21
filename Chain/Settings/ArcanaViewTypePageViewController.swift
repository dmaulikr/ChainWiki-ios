//
//  ArcanaViewTypePageViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/29/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaViewTypePageViewController: UIPageViewController {
    
    fileprivate let photos = [#imageLiteral(resourceName: "listPreview"), #imageLiteral(resourceName: "mainListPreview"), #imageLiteral(resourceName: "profilePreview"), #imageLiteral(resourceName: "mainGridPreview")]
    fileprivate var currentIndex: Int!
    var selectedArcanaViews: [SelectedArcanaView]?
    
    let tipView: UIView = {
        let view = UIView()
        view.alpha = 1
        view.backgroundColor = .white
        return view
    }()
    
    let logoImage: PCView = {
        let view = PCView()
        view.backgroundColor = .white
        return view
    }()
    
    let tipLabel: UILabel = {
       let label = UILabel()
        label.text = "아르카나 보기 방식이 총 4가지로\n업데이트 되었습니다!\n 다음 화면에서 구경하세요."
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "나중에 설정에서 변경 가능.\n시작하려면 아무데나 탭하세요:) "
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init(selectedArcanaViews: [SelectedArcanaView], showTip: Bool) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.selectedArcanaViews = selectedArcanaViews
        if showTip {
            tipView.alpha = 1
        }
        else {
            tipView.alpha = 0
        }
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
        
        view.addSubview(tipView)
        tipView.addSubview(logoImage)
        tipView.addSubview(tipLabel)
        tipView.addSubview(bottomLabel)
 
        tipView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        logoImage.anchor(top: tipView.topAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 50, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 100)
        logoImage.anchorCenterXToSuperview()
        
        let stackView = UIStackView(arrangedSubviews: [tipLabel, bottomLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 30
        
        tipView.addSubview(stackView)
        
        stackView.anchor(top: logoImage.bottomAnchor, leading: tipView.leadingAnchor, trailing: tipView.trailingAnchor, bottom: nil, topConstant: 50, leadingConstant: 30, trailingConstant: 30, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupViewControllers() {
        
        let index = currentIndex ?? 0
        let page = ArcanaViewTypeViewController(index: index, photo: photos[index], selectedArcanaViews: selectedArcanaViews)
        
        let viewControllers = [page]
        
        setViewControllers(
            viewControllers,
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tipView.alpha = 0
            self.tipView.removeFromSuperview()
        })
    }
    
}

extension ArcanaViewTypePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ArcanaViewTypeViewController {
            var index = viewController.tutorialIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index - 1
            return ArcanaViewTypeViewController(index: index, photo: photos[index], selectedArcanaViews: selectedArcanaViews)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ArcanaViewTypeViewController {
            
            let index = viewController.tutorialIndex
            let nextindex = index + 1
            
            if nextindex == photos.count {
                return nil
            }
            else {
                return ArcanaViewTypeViewController(index: nextindex, photo: photos[nextindex], selectedArcanaViews: selectedArcanaViews)
            }
            
        }
        return nil
    }
    
}

