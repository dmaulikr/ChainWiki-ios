//
//  AppRater.swift
//  Chain
//
//  Created by Jitae Kim on 10/23/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

class AppRater {
    
    static let appRater = AppRater()
    
    func incrementAppLaunches() {
        
        var launches = defaults.getAppLaunchCount()
        launches += 1
        defaults.setAppLaunches(value: launches)
        
    }
    
    func displayAlert() {
        
        guard defaults.hasShownRating() == false, defaults.getAppLaunchCount() > 10 else {
            return
        }
        defaults.setShownRating(value: true)
        
        let alert = UIAlertController(title: "리뷰 작성", message: "앱 경험을 리뷰로 작성해 주세요!", preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "리뷰하러 가기", style: .default) { (action) in
            if let url = NSURL(string: "itms-apps://itunes.apple.com/app/id1165642488") as? URL {
                UIApplication.shared.openURL(url)
            }
            
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


extension String {
    func versionToInt() -> [Int] {
        return self.components(separatedBy: ".")
            .map { Int.init($0) ?? 0 }
    }
}
