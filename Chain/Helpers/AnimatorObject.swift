//
//  AnimatorObject.swift
//  PresentationController
//
//  Created by Jitae Kim on 7/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AnimatorObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.8
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
        let detailVC = transitionContext.viewController(forKey: .to) as! NavigationController
        
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
            finalFrame = CGRect(x: 0, y: 20, width: detailVC.view.frame.width, height: detailVC.view.frame.width * 4/3)
        }
        else {
            let size = CGSize(width: 400, height: 600)
            let origin = CGPoint(x: detailVC.view.frame.width / 2 - size.width / 2, y: 100)
            finalFrame = CGRect(origin: origin, size: size)
        }
        
//        let transform = self.transformFromRect(from: detailVC.view.frame, toRect: initialFrame)
//        detailVC.view.transform = transform
//        detailVC.headerView.transform = transform
//
//        transitionContext.containerView.addSubview(detailVC.view)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.damping, initialSpringVelocity: self.springVelocity, options: .curveLinear, animations: {
            self.snapshotView.frame = finalFrame
//            detailVC.headerView.transform = .identity
//            detailVC.view.transform = .identity
            
        }) { finished in
//            self.snapshotView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                detailVC.view.alpha = 1
            })
            transitionContext.completeTransition(finished)
        }
        
    }
    
    func animateDismissal(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from) as! NavigationController
        let arcanaDetailView = fromVC.view!
        
        let toFrame = toVC.view.convert(self.thumbnailView.frame, from: self.thumbnailView.superview)
        let transform = transformFromRect(from: arcanaDetailView.frame, toRect: toFrame)
        arcanaDetailView.alpha = 0
        
        transitionContext.containerView.bringSubview(toFront: snapshotView)
        snapshotView.frame = fromVC.view.frame
        // Animate the transition.
//        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.damping, initialSpringVelocity: self.springVelocity, options: .curveLinear, animations: {
//        UIView.animate(withDuration: 0.2, animations: {
//            arcanaDetailView.transform = transform
//            arcanaDetailView.frame = toFrame
            self.snapshotView.frame = toFrame
            
        }) { finished in
            self.snapshotView.removeFromSuperview()
            self.thumbnailView.alpha = 1
            transitionContext.completeTransition(finished)
        }
        
    }
    
    func transformFromRect(from: CGRect, toRect to: CGRect) -> CGAffineTransform {
        let transform = CGAffineTransform(translationX: to.midX - from.midX, y: to.midY - from.midY)
        return transform.scaledBy(x: to.width/from.width, y: to.height/from.height)
    }
}
