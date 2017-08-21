//
//  PresentationController.swift
//  PresentationController
//
//  Created by Jitae Kim on 7/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    fileprivate var chromeView = UIView()
    var blurView: UIVisualEffectView!
    
    var compactConstraints = [NSLayoutConstraint]()
    var regularConstraints = [NSLayoutConstraint]()
    
//    override var frameOfPresentedViewInContainerView: CGRect {
//
//        guard let containerView = containerView else {
//            fatalError("Container view is nil")
//        }
//
//        let size: CGSize
//        let origin: CGPoint
//
//        if traitCollection.horizontalSizeClass == .compact {
//            size = containerView.bounds.size
//            origin = CGPoint(x: 0, y: 0)
//        }
//        else {
//            size = CGSize(width: 600, height: containerView.bounds.size.height - 100)
//            origin = CGPoint(x: containerView.frame.width / 2 - size.width / 2, y: 100)
//        }
//        let frame = CGRect(origin: origin, size: size)
//        return frame
//    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupBlurView()
    }
    
    func setupBlurView() {
        
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 1
        blurView.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blurView.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        
        guard let containerView = containerView else { fatalError("Container view is nil") }
        blurView.frame = containerView.bounds
        
        if traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
            presentedViewController.view.layer.cornerRadius = 0
        }
        else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
            presentedViewController.view.layer.masksToBounds = true
            presentedViewController.view.layer.cornerRadius = 5
//            let a = UIEdgeInsetsInsetRect(<#T##rect: CGRect##CGRect#>, <#T##insets: UIEdgeInsets##UIEdgeInsets#>)
        }
    }
    
    func setupConstraints() {
        
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let leadingConstraint = presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let trailingConstraint = presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        
        compactConstraints = [topConstraint, leadingConstraint, trailingConstraint, bottomConstraint]
        
        let widthConstraint = presentedView.widthAnchor.constraint(equalToConstant: 400)
        let heightConstraint = presentedView.heightAnchor.constraint(equalToConstant: containerView.frame.height - 100)
        let bottomRegularConstraint = presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        let centerXConstraint = presentedView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        
        regularConstraints = [widthConstraint, heightConstraint, bottomRegularConstraint, centerXConstraint]
    }
    
    func updatePresentedViewFrame(_ containerViewSize: CGSize) {
        
        let size: CGSize
        let origin: CGPoint
        
        if traitCollection.horizontalSizeClass == .compact {
            size = containerViewSize
            origin = CGPoint(x: 0, y: 0)
        }
        else {
            size = CGSize(width: 600, height: containerViewSize.height - 100)
            origin = CGPoint(x: containerViewSize.width / 2 - size.width / 2, y: 100)
        }
        let frame = CGRect(origin: origin, size: size)
        presentedView?.frame = frame
        
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        updatePresentedViewFrame(size)
//        blurView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        super.viewWillTransition(to: size, with: coordinator)
//    }
    
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
//        presentedView.frame = frameOfPresentedViewInContainerView
        
        setupConstraints()
        presentedView.layer.cornerRadius = 10
        
        containerView.insertSubview(blurView, at: 0)
        
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
            }, completion:nil)
        } else {
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.blurView.alpha = 0
            }, completion:nil)
        } else {
        }
        
    }
}
