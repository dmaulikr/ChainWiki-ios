//
//  TutorialViewController.swift
//  Chain
//
//  Created by Jitae Kim on 10/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    let tutorialIndex: Int
    let photo: UIImage
    let desc: String
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = Color.lightGreen
        return pageControl
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.tintColor = Color.lightGreen
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    init(index: Int, photo: UIImage, desc: String) {
        self.tutorialIndex = index
        self.photo = photo
        self.desc = desc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        imageView.image = photo
        descLabel.text = desc
        pageControl.currentPage = tutorialIndex
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Color.gray247

        view.addSubview(imageView)
        view.addSubview(descLabel)
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        imageView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        descLabel.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        descLabel.setContentHuggingPriority(.init(752), for: .vertical)
        descLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        pageControl.anchor(top: descLabel.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchorCenterXToSuperview()
        
        startButton.anchor(top: pageControl.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 60)
        startButton.setContentHuggingPriority(.init(755), for: .vertical)
        
        setupButtonBorder()
        
    }
    
    func setupButtonBorder() {
        let topBorder = UIView(frame: CGRect(x: 10, y: 0, width: SCREENWIDTH-20, height: 1))
        topBorder.backgroundColor = .lightGray
        startButton.addSubview(topBorder)
    }

    @objc func login() {
        changeRootVC(vc: .login)
    }
}
