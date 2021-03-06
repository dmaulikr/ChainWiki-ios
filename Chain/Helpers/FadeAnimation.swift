//
//  FadeAnimation.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func fadeIn(withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func fadeViewInThenOut(delay: TimeInterval) {
        
        let animationDuration = 0.2
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                self.alpha = 0
                },
                           completion: nil)
        }
    }
    
    func bounceAnimate() {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil)
    }
    
    func cellAnimate() {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = .identity
            },
                       completion: nil)
    }
    
    func filterViewAnimate() {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        })
//        var t = self.transform
//        t = t.translatedBy(x: self.frame.width, y: -self.frame.height)
//        t = t.scaledBy(x: 0.1, y: 0.1)
//
//        self.transform = t
//        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
//            self.alpha = 1
//            self.transform = .identity
//        }, completion: nil)

        
    }

}
