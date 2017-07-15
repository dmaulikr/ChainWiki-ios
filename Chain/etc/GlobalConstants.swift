
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
//    return UIScreen.main.bounds.size.width
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
    return SCREENWIDTH == 1366.0
}
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

let FIREBASE_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()
let storage = Storage.storage()

let ARCANA_REF = FIREBASE_REF.child("arcana")
let USERS_REF = FIREBASE_REF.child("user")
let FESTIVAL_REF = FIREBASE_REF.child("festival")
let LEGEND_REF = FIREBASE_REF.child("legend")
let REWARD_REF = FIREBASE_REF.child("reward")

// NotificationCenter
let ARCANAVIEWUPDATENOTIFICATIONNAME = Notification.Name("ArcanaViewUpdate")

// Fonts
let APPLEGOTHIC_17 = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)

enum ArcanaAttribute {
    
    static let arcanaID = "arcanaID"
    static let nameKR = "nameKR"
    static let nicknameKR = "nicknameKR"
    static let nameJP = "nameJP"
    static let nicknameJP = "nicknameJP"
    
    static let rarity = "rarity"
    static let group = "group"
    static let weapon = "weapon"
    static let affiliation = "affiliation"
    
    static let cost = "cost"
    static let tavern = "tavern"
    
    static let kizunaName = "kizunaName"
    static let kizunaCost = "kizunaCost"
    static let kizunaDesc = "kizunaDesc"
    
    static let skillCount = "skillCount"
    static let skillName1 = "skillName1"
    static let skillMana1 = "skillMana1"
    static let skillDesc1 = "skillDesc1"
    
    static let skillName2 = "skillName2"
    static let skillMana2 = "skillMana2"
    static let skillDesc2 = "skillDesc2"
    
    static let skillName3 = "skillName3"
    static let skillMana3 = "skillMana3"
    static let skillDesc3 = "skillDesc3"
    
    static let abilityName1 = "abilityName1"
    static let abilityDesc1 = "abilityDesc1"
    
    static let abilityName2 = "abilityName2"
    static let abilityDesc2 = "abilityDesc2"
    
    static let abilityName3 = "abilityName3"
    static let abilityDesc3 = "abilityDesc3"
    
    static let partyAbility = "partyAbility"
    
    static let chainStory = "chainStory"
    
}

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



