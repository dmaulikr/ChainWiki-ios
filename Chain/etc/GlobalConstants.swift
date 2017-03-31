
//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

var NICKNAME: String? {
    if let NICKNAME = UserDefaults.standard.value(forKey: "nickName") as? String {
        return (NICKNAME)
        
    }
    else {
        return nil
    }
}

// Size Classes and Devices

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

let horizontalSize = UIScreen.main.traitCollection.horizontalSizeClass
let verticalSize = UIScreen.main.traitCollection.verticalSizeClass
var ISIPADPRO: Bool {
    return SCREENHEIGHT == 1366.0
}


let FIREBASE_REF = FIRDatabase.database().reference()
let STORAGE_REF = FIRStorage.storage().reference()
let storage = FIRStorage.storage()
//
//let SCREENWIDTH = UIScreen.main.bounds.width
//let SCREENHEIGHT = UIScreen.main.bounds.height






// Colors
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

enum Color {
    
    static let salmon = UIColor(red:0.92, green:0.65, blue:0.63, alpha:1.0) // #EBA5A0
    static let darkSalmon = UIColor(red:0.82, green:0.24, blue:0.32, alpha:1.0)
    static let lightGray = UIColor(red:0.86, green:0.88, blue:0.9, alpha:1.0)  // #dbe0e6
    static let lightGreen = UIColor(red:0.41, green:0.64, blue:0.51, alpha:1.0) // #68a283
    static let textGray = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)  // #878787
    static let gray247 = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)    // #f7f7f7
    static let googleRed = UIColor(red:0.86, green:0.20, blue:0.21, alpha:1.0) // #db3236
    static let facebookBlue = UIColor(netHex: 0x3b5998)

}

let defaults = UserDefaults.standard

extension UIViewController {
    
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



