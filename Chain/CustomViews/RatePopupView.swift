//
//  RatePopupView.swift
//  Chain
//
//  Created by Jitae Kim on 6/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class RatePopupView: UIView {

    weak var arcanaDetailDelegate: ArcanaDetail?
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 디자인이 마음에 드시나요?"
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        label.textColor = Color.textGray
        label.textAlignment = .center
        return label
    }()
    
    let underline = HorizontalBar()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("좋아요", for: .normal)
        button.setTitleColor(Color.lightGreen, for: .normal)
        button.addTarget(self, action: #selector(like), for: .touchUpInside)
        return button

    }()
    
    lazy var surveyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개선 의견 내기", for: .normal)
        button.setTitleColor(Color.textGray, for: .normal)
        button.addTarget(self, action: #selector(survey), for: .touchUpInside)
        return button
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = Color.lightGray.cgColor
        layer.cornerRadius = 3
        
        addSubview(questionLabel)
        addSubview(underline)
        
        addSubview(likeButton)
        addSubview(surveyButton)
        addSubview(declineButton)
        
        questionLabel.anchor(top: topAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 5, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        questionLabel.anchorCenterXToSuperview()
        underline.anchor(top: questionLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 5, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, surveyButton, declineButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: questionLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    func like() {
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//            AnalyticsParameterItemID:
//            ])
        let thanksLabel = UILabel()
        thanksLabel.text = "감사합니다!"
        
        let thanksView = UIView()
        thanksView.backgroundColor = .white
        thanksView.alpha = 0
        
        thanksView.addSubview(thanksLabel)
        thanksLabel.anchorCenterSuperview()
        
        addSubview(thanksView)
        
        thanksView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        UIView.animate(withDuration: 0.2, animations: {
            thanksView.alpha = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
            }, completion: { finished in
                self.removeFromSuperview()
            })
        }
    }
    
    func survey() {
        let vc = SurveyPageViewController()
        arcanaDetailDelegate?.present(NavigationController(vc), animated: true, completion: nil)
    }
    
    func hidePopup() {
        defaults.setViewedSurvey()
        removeFromSuperview()
    }

}
