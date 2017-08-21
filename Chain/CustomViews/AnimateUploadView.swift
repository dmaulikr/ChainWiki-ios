//
//  AnimateUploadView.swift
//  Chain
//
//  Created by Jitae Kim on 6/16/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AnimateUploadView: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.font = APPLEGOTHIC_17
        label.text = "아르카나 정보 불러오는 중..."
        label.textAlignment = .center
        return label
    }() 
    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: Color.lightGreen, padding: 0)
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        backgroundColor = .black
        
        addSubview(containerView)
        containerView.addSubview(progressLabel)
        containerView.addSubview(activityIndicator)
        
        containerView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 100)
        containerView.anchorCenterYToSuperview()
        
        progressLabel.anchor(top: containerView.topAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        progressLabel.anchorCenterXToSuperview()
        
        activityIndicator.anchor(top: progressLabel.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        activityIndicator.anchorCenterXToSuperview()
    }
    
    func setLabel(_ text: String) {
        progressLabel.alpha = 0
        progressLabel.text = text
        progressLabel.fadeIn()
    }
}
