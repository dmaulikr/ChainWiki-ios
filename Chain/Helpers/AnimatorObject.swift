//
//  AnimatorObject.swift
//  PresentationController
//
//  Created by Jitae Kim on 7/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AnimatorObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    let damping: CGFloat = 0.7
    let springVelocity: CGFloat = 0.1
    
//    let thumbnailView: UIView
    var snapshotView = UIView()
    var thumbnailView = UIView()
    var isPresentation = true
    // MARK: - Properties
//    let isPresentation: Bool
    
    // MARK: - Initializers
//    init(isPresentation: Bool, thumbnailView: UIView) {
//        self.isPresentation = isPresentation
//        self.thumbnailView = thumbnailView
//        super.init()
//    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if (isPresentation) {
            animatePresentation(transitionContext)
        }
        else {
            animateDismissal(transitionContext)
        }

    }

    func animatePresentation(_ transitionContext: UIViewControllerContextTransitioning) {
        
        self.thumbnailView.alpha = 0
        
        let fromVC = transitionContext.viewController(forKey: .from)!
//        let detailVC = transitionContext.viewController(forKey: .to) as! NavigationController
        let detailVC = transitionContext.viewController(forKey: .to) as! ArcanaDetail
        let initialFrame = fromVC.view.convert(self.thumbnailView.frame, from: self.thumbnailView.superview)
        let finalFrame: CGRect
        
        snapshotView = thumbnailView.snapshotView(afterScreenUpdates: false)!
        snapshotView.layer.cornerRadius = 3
        snapshotView.layer.masksToBounds = true
        snapshotView.frame = initialFrame
        
        transitionContext.containerView.addSubview(snapshotView)
        
        transitionContext.containerView.addSubview(detailVC.view)
        detailVC.view.alpha = 0
        
        if detailVC.traitCollection.horizontalSizeClass == .compact {
//            let size = CGSize(width: detailVC.view.frame.width, height: detailVC.view.frame.width * 4/3)
            let height = CGFloat(min(detailVC.view.frame.width * 1.5, 650))
            let x = (650 - detailVC.view.frame.width)/2
            if height == 650 {
                finalFrame = CGRect(x: x, y: 20, width: height * 2/3, height: height)
            }
            else {
                finalFrame = CGRect(x: 0, y: 20, width: height * 2/3, height: height)
            }
            
        }
        else {
            let size = CGSize(width: 400, height: 600)
            let origin = CGPoint(x: detailVC.view.frame.width / 2 - size.width / 2, y: 100)
            finalFrame = CGRect(origin: origin, size: size)
        }

        let transform = transformFromRect(from: initialFrame, toRect: finalFrame)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.damping, initialSpringVelocity: self.springVelocity, options: .curveLinear, animations: {

            self.snapshotView.transform = transform
            
        }) { finished in

            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    detailVC.view.alpha = 1
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.snapshotView.alpha = 0
                })
                
            }, completion: { (finished) in
                transitionContext.completeTransition(finished)
            })
        }
        
    }
    
    func animateDismissal(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)!
//        let fromVC = transitionContext.viewController(forKey: .from) as! NavigationController
        let fromVC = transitionContext.viewController(forKey: .from) as! ArcanaDetail
        let arcanaDetailView = fromVC.view!
        
        let toFrame = toVC.view.convert(self.thumbnailView.frame, from: self.thumbnailView.superview)
        let transform = transformFromRect(from: arcanaDetailView.frame, toRect: toFrame)
        arcanaDetailView.alpha = 0
        
        transitionContext.containerView.bringSubview(toFront: snapshotView)
        snapshotView.alpha = 1
        // Animate the transition.
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.damping, initialSpringVelocity: self.springVelocity, options: .curveLinear, animations: {

            self.snapshotView.transform = .identity
            
        }) { finished in
            if (!transitionContext.transitionWasCancelled) {
                self.snapshotView.removeFromSuperview()
                self.thumbnailView.alpha = 1
            }
            else {
//                transitionContext.containerView.bringSubview(toFront: arcanaDetailView)
                arcanaDetailView.alpha = 1
                self.snapshotView.alpha = 0
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transformFromRect(from: CGRect, toRect to: CGRect) -> CGAffineTransform {
        let transform = CGAffineTransform(translationX: to.midX - from.midX, y: to.midY - from.midY)
        return transform.scaledBy(x: to.width/from.width, y: to.height/from.height)
    }
}
