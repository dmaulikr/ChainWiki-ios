
//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

var USERID: String? {
    if let USERID = UserDefaults.standard.value(forKey: "uid") as? String {
        return (USERID)
        
    }
    else {
        return nil
    }
}

var NICKNAME: String? {
    if let NICKNAME = UserDefaults.standard.value(forKey: "nickName") as? String {
        return (NICKNAME)
        
    }
    else {
        return nil
    }
}

let FIREBASE_REF = FIRDatabase.database().reference()
let STORAGE_REF = FIRStorage.storage().reference()
//
//let SCREENWIDTH = UIScreen.main.bounds.width
//let SCREENHEIGHT = UIScreen.main.bounds.height


var SCREENWIDTH: CGFloat {
    if UIInterfaceOrientationIsPortrait(SCREENORIENTATION) {
        return UIScreen.main.bounds.size.width
    } else {
        return UIScreen.main.bounds.size.height
    }
}
var SCREENHEIGHT: CGFloat {
    if UIInterfaceOrientationIsPortrait(SCREENORIENTATION) {
        return UIScreen.main.bounds.size.height
    } else {
        return UIScreen.main.bounds.size.width
    }
}
var SCREENORIENTATION: UIInterfaceOrientation {
    return UIApplication.shared.statusBarOrientation
}


let DOWNLOADER = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .fifo,
    maximumActiveDownloads: 4,
    imageCache: AutoPurgingImageCache()
)

let IMAGECACHE = AutoPurgingImageCache(
    memoryCapacity: 100 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
)


// Colors
enum Color {
    
    static let salmon = UIColor(red:0.92, green:0.65, blue:0.63, alpha:1.0) // #EBA5A0
    static let darkSalmon = UIColor(red:0.82, green:0.24, blue:0.32, alpha:1.0)
    static let lightGray = UIColor(red:0.86, green:0.88, blue:0.9, alpha:1.0)
    static let lightGreen = UIColor(red:0.41, green:0.64, blue:0.51, alpha:1.0) // #68a283
    static let textGray = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)
    static let gray247 = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)    // #f7f7f7
}

let defaults = UserDefaults.standard

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in }
        
        alert.addAction(confirmAction)        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
        }
    }
}

public extension UIView {
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }

    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func fadeViewInThenOut(delay: TimeInterval) {
        
        let animationDuration = 1.0
        
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
}

