//
//  ZoomingTransitionAnimator.swift
//  Chain
//
//  Created by Jitae Kim on 7/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ZoomingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    var operation: UINavigationControllerOperation = .push
    var thumbnailFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presenting = operation == .push
        
        // Determine which is the master view and which is the detail view that we're navigating to and from. The container view will house the views for transition animation.
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        let homeView = presenting ? fromView : toView
        let arcanaDetailView = presenting ? toView : fromView
        
        // Determine the starting frame of the detail view for the animation. When we're presenting, the detail view will grow out of the thumbnail frame. When we're dismissing, the detail view will shrink back into that same thumbnail frame.
        var initialFrame = presenting ? thumbnailFrame : arcanaDetailView.frame
        let finalFrame = presenting ? arcanaDetailView.frame : thumbnailFrame
        
        // Resize the detail view to fit within the thumbnail's frame at the beginning of the push animation and at the end of the pop animation while maintaining it's inherent aspect ratio.
        let initialFrameAspectRatio = initialFrame.width / initialFrame.height
        let arcanaDetailAspectRatio = arcanaDetailView.frame.width / arcanaDetailView.frame.height
        if initialFrameAspectRatio > arcanaDetailAspectRatio {
            initialFrame.size = CGSize(width: initialFrame.height * arcanaDetailAspectRatio, height: initialFrame.height)
        }
        else {
            initialFrame.size = CGSize(width: initialFrame.width, height: initialFrame.width / arcanaDetailAspectRatio)
        }
        
        let finalFrameAspectRatio = finalFrame.width / finalFrame.height
        var resizedFinalFrame = finalFrame
        if finalFrameAspectRatio > arcanaDetailAspectRatio {
            resizedFinalFrame.size = CGSize(width: finalFrame.height * arcanaDetailAspectRatio, height: finalFrame.height)
        }
        else {
            resizedFinalFrame.size = CGSize(width: finalFrame.width, height: finalFrame.width / arcanaDetailAspectRatio)
        }
        
        // Determine how much the detail view needs to grow or shrink.
        let scaleFactor = resizedFinalFrame.width / initialFrame.width
        let growScaleFactor = presenting ? scaleFactor: 1/scaleFactor
        let shrinkScaleFactor = 1/growScaleFactor
        
        if presenting {
            // Shrink the detail view for the initial frame. The detail view will be scaled to CGAffineTransformIdentity below.
            arcanaDetailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
            arcanaDetailView.center = CGPoint(x: thumbnailFrame.midX, y: thumbnailFrame.midY)
            arcanaDetailView.clipsToBounds = true
        }
        
        // Set the initial state of the alpha for the master and detail views so that we can fade them in and out during the animation.
        arcanaDetailView.alpha = presenting ? 0 : 1
        homeView.alpha = presenting ? 1 : 0
        
        // Add the view that we're transitioning to to the container view that houses the animation.
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: arcanaDetailView)
        
        // Animate the transition.
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            // Fade the master and detail views in and out.
            arcanaDetailView.alpha = presenting ? 1 : 0
            homeView.alpha = presenting ? 0 : 1
            
            if presenting {
                // Scale the master view in parallel with the detail view (which will grow to its inherent size). The translation gives the appearance that the anchor point for the zoom is the center of the thumbnail frame.
                let scale = CGAffineTransform(scaleX: growScaleFactor, y: growScaleFactor)
                
                let translate = CGAffineTransform(translationX: homeView.frame.midX - self.thumbnailFrame.midX, y: homeView.frame.midY - self.thumbnailFrame.midY)
                homeView.transform = translate.concatenating(scale)
                arcanaDetailView.transform = .identity
            }
            else {
                // Return the master view to its inherent size and position and shrink the detail view.
                homeView.transform = .identity
                arcanaDetailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
            }
            
            // Move the detail view to the final frame position.
            arcanaDetailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { finished in
            transitionContext.completeTransition(finished)
        }
        
    }
    
}
