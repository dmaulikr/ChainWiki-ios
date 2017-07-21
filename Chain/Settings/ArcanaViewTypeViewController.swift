//
//  ArcanaViewTypeViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/29/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaViewTypeViewController: UIViewController {

    let tutorialIndex: Int
    let photo: UIImage
    var selectedArcanaViews: [SelectedArcanaView]?

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = Color.lightGreen
        return pageControl
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.tintColor = Color.lightGreen
        button.addTarget(self, action: #selector(selectView), for: .touchUpInside)
        return button
    }()

    init(index: Int, photo: UIImage, selectedArcanaViews: [SelectedArcanaView]?) {
        self.tutorialIndex = index
        self.photo = photo
        self.selectedArcanaViews = selectedArcanaViews
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        imageView.image = photo
        pageControl.currentPage = tutorialIndex
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = Color.gray247
        
        view.addSubview(imageView)
        view.addSubview(pageControl)
        view.addSubview(selectButton)
        
        imageView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        pageControl.anchor(top: imageView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchorCenterXToSuperview()
        
        selectButton.anchor(top: pageControl.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 60)
        selectButton.setContentHuggingPriority(.init(755), for: .vertical)
        
        setupButtonBorder()
        
    }

    func setupButtonBorder() {
        let topBorder = UIView(frame: CGRect(x: 10, y: 0, width: SCREENWIDTH-20, height: 1))
        topBorder.backgroundColor = .lightGray
        selectButton.addSubview(topBorder)
    }


    @objc func selectView() {
        
        guard let selectedArcanaViews = selectedArcanaViews else { return }
        
        if selectedArcanaViews.contains(.all) {
            
            if tutorialIndex == 0 {
                defaults.setAllArcanaView(value: "list")
            }
            else {
                defaults.setAllArcanaView(value: "main")
            }
            
        }
        
        else {
            if selectedArcanaViews.contains(.search) {
                
                if tutorialIndex == 0 {
                    defaults.setAllArcanaView(value: "list")
                }
                else {
                    defaults.setAllArcanaView(value: "main")
                }

            }
            if selectedArcanaViews.contains(.tavern) {
                
                if tutorialIndex == 0 {
                    defaults.setAllArcanaView(value: "list")
                }
                else {
                    defaults.setAllArcanaView(value: "main")
                }

            }
            if selectedArcanaViews.contains(.favorites) {
                
                if tutorialIndex == 0 {
                    defaults.setAllArcanaView(value: "list")
                }
                else {
                    defaults.setAllArcanaView(value: "main")
                }

            }

        }
        
        
        defaults.setShowedArcanaViewSelection(value: true)
        
        NotificationCenter.default.post(name: ARCANAVIEWUPDATENOTIFICATIONNAME, object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
}
