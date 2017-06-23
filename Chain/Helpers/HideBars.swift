//
//  HideBars.swift
//  Chain
//
//  Created by Jitae Kim on 6/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

class HideBarsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var tableViewBottomConstraint: NSLayoutConstraint?
    
    @objc func handleBars() {
        
        if horizontalSize != .compact { return }
        if let hidden = navigationController?.isNavigationBarHidden, hidden == false {
            hideBars()
        }
        else {
            showBars()
        }
    }
    
    func showBars() {
        
        if horizontalSize != .compact { return }
        
        if let hidden = navigationController?.isNavigationBarHidden, hidden == false {
            return
        }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNeedsStatusBarAppearanceUpdate()
        
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.size.height - frame.size.height
        
        self.tableViewBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tabBarController?.tabBar.frame = frame
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func hideBars() {
        
        if horizontalSize != .compact { return }
        
        if let hidden = navigationController?.isNavigationBarHidden, hidden == true {
            return
        }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        setNeedsStatusBarAppearanceUpdate()
        
        guard var frame = tabBarController?.tabBar.frame else { return }
        frame.origin.y = view.frame.size.height + frame.size.height
        
        self.tableViewBottomConstraint?.constant = 50
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tabBarController?.tabBar.frame = frame
            self.view.layoutIfNeeded()
            
        }, completion: nil )
        
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        showBars()
    }
    
    @objc
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let superview = scrollView.superview else { return }
        
        let translation = scrollView.panGestureRecognizer.translation(in: superview)
        
        if translation.y < 0 {
            
            // if moving down the tableView
            self.hideBars()
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            
        }
        
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard let superview = scrollView.superview else { return }
        
        let translation = scrollView.panGestureRecognizer.translation(in: superview)
        
        if decelerate == true {
            if translation.y > 0 {
                showBars()
            }
        }
    }
    
}
