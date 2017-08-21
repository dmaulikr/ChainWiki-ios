//
//  AppRater.swift
//  Chain
//
//  Created by Jitae Kim on 10/23/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import StoreKit

class AppRater {
    
    static let appRater = AppRater()
    
    func incrementAppLaunches() {
        let count = defaults.getAppLaunchCount()
        if count > 10 && !defaults.hasShownRating() {
            
            defaults.setShownRating(value: true)
            
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }
            else {
                displayAlert()
            }
        }
        defaults.setAppLaunches(value: count + 1)
    }
    
    func incrementArcanaDetailViews() {
        let count = defaults.getArcanaDetailViewCount()
        defaults.setArcanaDetailViews(value: count + 1)
    }
    
    func displayAlert() {
        
        let alert = UIAlertController(title: "리뷰 작성", message: "앱 경험을 리뷰로 작성해 주세요!", preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "리뷰하러 가기", style: .default) { (action) in
            guard let url = NSURL(string: "itms-apps://itunes.apple.com/app/id1165642488") as URL? else { return }
            UIApplication.shared.openURL(url)
        }
        
        let cancelAction = UIAlertAction(title: "다시 보지 않기", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        let window = UIApplication.shared.windows[0]
        window.rootViewController?.present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
        }

    }
    
}

