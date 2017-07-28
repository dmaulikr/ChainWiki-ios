//
//  AnimatedLogoView.swift
//  Chain
//
//  Created by Jitae Kim on 6/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AnimatedLogoView: UIView {
    
    // this will be animated to fill the view
    let fillView = UIView()
    
    // the image to be filled
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "AppLogo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        backgroundColor = Color.gray247
        fillView.backgroundColor = Color.lightGreen
        
        addSubview(fillView)
        mask = logoImageView
        
        layoutIfNeeded()
        reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fillView.frame = self.bounds
        logoImageView.frame = self.bounds
    }
    
    func reset() {
        fillView.frame.origin.y = bounds.height
    }
    
    func finishAnimation() {
        fillView.frame.origin.y = 0
        fillView.layer.removeAllAnimations()
    }
    
    func animate() {
        reset()
        
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            self.fillView.frame.origin.y = 0
        }) { (finished) in
            
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.transform = .identity
            }, completion: nil)
            
        }
        
    }
}
