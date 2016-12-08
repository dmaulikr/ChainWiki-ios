//
//  BannerAlert.swift
//  Chain
//
//  Created by Jitae Kim on 12/6/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol DisplayBanner {
    func displayBanner(desc: String, color: UIColor)
}

extension DisplayBanner where Self: UIViewController {
    
    func displayBanner(desc: String, color: UIColor = Color.googleRed) {
        let banner = BannerAlert(desc: desc, color: color)
        
        self.view.addSubview(banner)
        
        banner.translatesAutoresizingMaskIntoConstraints = false
        // regular constraints
        let initialHeight = banner.heightAnchor.constraint(equalToConstant: 0)
        initialHeight.isActive = true
        banner.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        banner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        banner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tabBarController?.tabBar.isHidden = true
        self.view.layoutIfNeeded()
        
        // animate this from bottom up
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            initialHeight.isActive = false
            banner.heightAnchor.constraint(equalToConstant: 60).isActive = true
            self.view.layoutIfNeeded()
        }, completion: {
            (Bool) -> Void in
            UIView.animate(withDuration: 0.2, delay: 5, options: .curveEaseOut, animations: {
                banner.alpha = 0
                
            }, completion: { finished in
                banner.removeFromSuperview()
                self.tabBarController?.tabBar.isHidden = false
            })
        })
        
        
    }
    
}

class BannerAlert: UIView {

//    var titleLabel = UILabel()
    
    var descLabel = UILabel()
    let icon = UIImageView(image: #imageLiteral(resourceName: "exclamation"))
    
    init(desc: String, color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = color
//        titleLabel.text = title
//        titleLabel.textColor = .white
        descLabel.text = desc
        descLabel.textColor = .white
        descLabel.textAlignment = .center
        descLabel.font = UIFont(name: "Apple SD Gothic Neo-Medium", size: 15)
        setupViews()
    }
    
    func setupViews() {
        
//        self.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: 10).isActive = true
//        titleLabel.setContentHuggingPriority(1000, for: .vertical)
        
        self.addSubview(descLabel)
        self.addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        icon.trailingAnchor.constraint(equalTo: descLabel.leadingAnchor, constant: 10).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        descLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
//        descLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        descLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
//        descLabel.setContentHuggingPriority(500, for: .vertical)
        self.layoutIfNeeded()
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
