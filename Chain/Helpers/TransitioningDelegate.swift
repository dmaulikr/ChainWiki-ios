//
//  TransitioningDelegate.swift
//  PresentationController
//
//  Created by Jitae Kim on 7/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class TransitioningDelegate: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {

    private let thumbnailView: UIView
    var animator = AnimatorObject()
    
    var interactionInProgress = false
    var shouldCompleteTransition = false
    weak var viewController: UIViewController!
    
    init(thumbnailView: UIView) {
        self.thumbnailView = thumbnailView
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
//        presentationController.delegate = self
        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresentation = true
        animator.thumbnailView = thumbnailView
        return animator
//        return AnimatorObject(isPresentation: true, thumbnailView: thumbnailView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresentation = false
        animator.thumbnailView = thumbnailView
        return animator
//        return AnimatorObject(isPresentation: false, thumbnailView: thumbnailView)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func wireToViewController(viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController: viewController)
    }
    
    private func prepareGestureRecognizerInView(viewController: UIViewController) {
        let backGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        backGesture.edges = UIRectEdge.left
        viewController.view.addGestureRecognizer(backGesture)
        
        let downGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDownGesture(_:)))
        if let detailVC = viewController as? ArcanaDetail {
            detailVC.tableView.panGestureRecognizer.addTarget(self, action: #selector(handleDownGesture(_:)))
        }
        else {
            viewController.view.addGestureRecognizer(downGesture)
        }
    }
    
    @objc func handleDownGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
        var progress = (translation.y / 400)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        if let originView = gestureRecognizer.view as? UITableView {
            if !interactionInProgress && (originView.contentOffset.y > 0 || translation.y < 0) {
                return
            }
        }

        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
        
    }
    
    @objc func handleBackGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
    
}

//// MARK: - UIAdaptivePresentationControllerDelegate
//extension TransitioningDelegate: UIAdaptivePresentationControllerDelegate {
//
//    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        if traitCollection.verticalSizeClass == .compact {
//            return .overFullScreen
//        } else {
//            return .custom
//        }
//    }
//
//    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//
//        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
//    }
//}

