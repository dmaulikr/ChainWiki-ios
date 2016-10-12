//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

struct ArcanaEdit {
    
    var uid: String?
    var nameKR: String?
    var nickNameKR: String?
    var nameJP: String?
    var nickNameJP: String?
    var rarity: String?
    var group: String?  // Class, 직업
    var tavern: String?  // 주점
    var affiliation: String? // 소속
    var cost: String?
    var weapon: String?
    
    var kizunaName: String?
    var kizunaCost: String?
    var kizunaDesc: String?
    
    var skillName1 : String?
    var skillMana1 : String?
    var skillDesc1 : String?
    
    var skillName2 : String?
    var skillMana2 : String?
    var skillDesc2 : String?
    
    var skillName3 : String?
    var skillMana3 : String?
    var skillDesc3 : String?
    
    var abilityName1: String?
    var abilityDesc1: String?
    
    var abilityName2: String?
    var abilityDesc2: String?
    
    var abilityName3: String?
    var abilityDesc3: String?
    
    var dateAdded: String?
    var chainStory: String?
    var chainStone: String?
    
    init?(snapshot: FIRDataSnapshot) {
        
        if let u = (snapshot.value as? NSDictionary)?["uid"] as? String {
            uid = u
        }

        if let nKR = (snapshot.value as? NSDictionary)?["nameKR"] as? String {
            nameKR = nKR
        }
        if let nJP = (snapshot.value as? NSDictionary)?["nameJP"] as? String {
            nameJP = nJP
        }
        if let r = (snapshot.value as? NSDictionary)?["rarity"] as? String {
            rarity = r
        }
        if let g = (snapshot.value as? NSDictionary)?["group"] as? String {
            group = g
        }
        if let t = (snapshot.value as? NSDictionary)?["tavern"] as? String {
            tavern = t
        }
        if let a = (snapshot.value as? NSDictionary)?["affiliation"] as? String {
            affiliation = a
        }
        if let c = (snapshot.value as? NSDictionary)?["cost"] as? String {
            cost = c
        }
        if let w = (snapshot.value as? NSDictionary)?["weapon"] as? String {
            weapon = w
        }
        
        if let kN = (snapshot.value as? NSDictionary)?["kizunaName"] as? String {
            kizunaName = kN
        }
        if let kC = (snapshot.value as? NSDictionary)?["kizunaCost"] as? String {
            kizunaCost = kC
        }
        if let kD = (snapshot.value as? NSDictionary)?["kizunaDesc"] as? String {
            kizunaDesc = kD
        }
        
        if let sN1 = (snapshot.value as? NSDictionary)?["skillName1"] as? String {
            skillName1 = sN1
        }
        if let sM1 = (snapshot.value as? NSDictionary)?["skillMana1"] as? String {
            skillMana1 = sM1
        }
        if let sD1 = (snapshot.value as? NSDictionary)?["skillDesc1"] as? String {
            skillDesc1 = sD1
        }
        
        if let sN2 = (snapshot.value as? NSDictionary)?["skillName2"] as? String {
            skillName2 = sN2
        }
        if let sM2 = (snapshot.value as? NSDictionary)?["skillMana2"] as? String {
            skillName2 = sM2
        }
        if let sD2 = (snapshot.value as? NSDictionary)?["skillDesc2"] as? String {
            skillName2 = sD2
        }
        
        if let sN3 = (snapshot.value as? NSDictionary)?["skillName3"] as? String {
            skillName3 = sN3
        }
        if let sM3 = (snapshot.value as? NSDictionary)?["skillMana3"] as? String {
            skillMana3 = sM3
        }
        if let sN3 = (snapshot.value as? NSDictionary)?["skillDesc3"] as? String {
            skillDesc3 = sN3
        }
        if let nnKR = (snapshot.value as? NSDictionary)?["nickNameKR"] as? String {
            nickNameKR = nnKR
        }
        
        if let nnJP = (snapshot.value as? NSDictionary)?["nickNameJP"] as? String {
            nickNameJP = nnJP
        }
        
        if let aN1 = (snapshot.value as? NSDictionary)?["abilityName1"] as? String {
            abilityName1 = aN1
        }
        
        if let aD1 = (snapshot.value as? NSDictionary)?["abilityDesc1"] as? String {
            abilityDesc1 = aD1
        }
        
        if let aN2 = (snapshot.value as? NSDictionary)?["abilityName2"] as? String {
            abilityName2 = aN2
        }
        
        if let aD2 = (snapshot.value as? NSDictionary)?["abilityDesc2"] as? String {
            abilityDesc2 = aD2
        }
        
        if let aN3 = (snapshot.value as? NSDictionary)?["abilityName3"] as? String {
            abilityName3 = aN3
        }
        
        if let aD3 = (snapshot.value as? NSDictionary)?["abilityDesc3"] as? String {
            abilityDesc3 = aD3
        }
        
        if let d = (snapshot.value as? NSDictionary)?["dateAdded"] as? String {
            dateAdded = d
        }
        
        if let cStory = (snapshot.value as? NSDictionary)?["chainStory"] as? String {
            chainStory = cStory
        }
        
        if let cStone = (snapshot.value as? NSDictionary)?["chainStone"] as? String {
            chainStone = cStone
        }
        
        
        
    }
    
    
    
}

