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
    
    func displayBanner(desc: String, color: UIColor = Color.salmon) {
        let banner = BannerAlert(desc: desc, color: color)
        
        self.view.addSubview(banner)
        
        banner.alpha = 0
        banner.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            banner.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: {
            (Bool) -> Void in
            UIView.animate(withDuration: 0.2, delay: 3, options: .curveEaseOut, animations: {
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
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
//    let icon = UIImageView(image: #imageLiteral(resourceName: "exclamation"))
    
    init(desc: String, color: UIColor) {
        super.init(frame: .zero)

        backgroundColor = color
        descLabel.text = desc
        setupViews()
    }
    
    func setupViews() {
        
//        self.addSubview(icon)
        self.addSubview(descLabel)
        
//        icon.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        descLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
//        descLabel.anchorCenterYToSuperview()
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
