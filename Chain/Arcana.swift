//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

struct Arcana: Equatable, Hashable {
    
    var uid: String
    var nameKR: String
    var nickNameKR: String?
    var nameJP: String
    var nickNameJP: String?
    var rarity: String
    var group: String  // Class, 직업
    var tavern: String  // 주점
    var affiliation: String? // 소속
    var cost: String
    var weapon: String

    var kizunaName: String
    var kizunaCost: String
    var kizunaDesc: String
    
    var skillCount : String
    
    var skillName1 : String
    var skillMana1 : String
    var skillDesc1 : String
    
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
    
    var numberOfViews: Int
    var dateAdded: String?
    var chainStory: String?
    var chainStone: String?
    
    var hashValue: Int {
        return uid.hashValue
    }
    
    

    
    
    init?(u: String, nKR: String, nnKR: String, nJP: String, nnJP: String, r: String, g: String, t: String, a: String, c: String, w: String, kN: String, kC: String, kD: String, sC: String, sN1: String, sM1: String, sD1: String, sN2: String, sM2: String, sD2: String, sN3: String, sM3: String, sD3: String, aN1: String, aD1: String, aN2: String, aD2: String, v: Int) {
        
        uid = u
        nameKR = nKR
        nickNameKR = nnKR
        nameJP = nJP
        nickNameJP = nnJP
        rarity = r
        group = g
        tavern = t
        affiliation = a
        cost = c
        weapon = w
        
        kizunaName  = kN
        kizunaCost = kC
        kizunaDesc = kD
        
        skillCount = sC
        
        skillName1 = sN1
        skillMana1 = sM1
        skillDesc1 = sD1
        
        skillName2 = sN2
        skillMana2 = sM2
        skillDesc2 = sD2
        
        skillName3 = sN3
        skillMana3 = sM3
        skillDesc3 = sD3
        
        abilityName1 = aN1
        abilityDesc1 = aD1
        
        abilityName2 = aN2
        abilityDesc2 = aD2
        
        numberOfViews = v
        
        
    }
    

 
    init?(snapshot: FIRDataSnapshot) {
        
//        if let a = snapshot.value as? NSDictionary {
//            let b = a["uid"] as? String
//        }
        guard let u = (snapshot.value as? NSDictionary)?["uid"] as? String, let nKR = (snapshot.value as? NSDictionary)?["nameKR"] as? String, let nJP = (snapshot.value as? NSDictionary)?["nameJP"] as? String, let r = (snapshot.value as? NSDictionary)?["rarity"] as? String, let g = (snapshot.value as? NSDictionary)?["class"] as? String, let t = (snapshot.value as? NSDictionary)?["tavern"] as? String, let a = (snapshot.value as? NSDictionary)?["affiliation"] as? String, let c = (snapshot.value as? NSDictionary)?["cost"] as? String, let w = (snapshot.value as? NSDictionary)?["weapon"] as? String, let kN = (snapshot.value as? NSDictionary)?["kizunaName"] as? String, let kC = (snapshot.value as? NSDictionary)?["kizunaCost"] as? String, let kD = (snapshot.value as? NSDictionary)?["kizunaDesc"] as? String, let sC = (snapshot.value as? NSDictionary)?["skillCount"] as? String, let sN1 = (snapshot.value as? NSDictionary)?["skillName1"] as? String, let sM1 = (snapshot.value as? NSDictionary)?["skillMana1"] as? String, let sD1 = (snapshot.value as? NSDictionary)?["skillDesc1"] as? String, let v = (snapshot.value as? NSDictionary)?["numberOfViews"] as? Int else {
                print("COULD NOT GET SNAPSHOT OF 1 SKILL ARCANA")
                return nil
            }
        
            uid = u
            nameKR = nKR
            nameJP = nJP
            rarity = r
            group = g
            tavern = t
            affiliation = a
            cost = c
            weapon = w
            
            kizunaName  = kN
            kizunaCost = kC
            kizunaDesc = kD
            
            skillCount = sC
            
            skillName1 = sN1
            skillMana1 = sM1
            skillDesc1 = sD1
            
            numberOfViews = v
        
        if let nnKR = (snapshot.value as? NSDictionary)?["nickNameKR"] as? String, let nnJP = (snapshot.value as? NSDictionary)?["nickNameJP"] as? String {
            nickNameKR = nnKR
            nickNameJP = nnJP
        }
        
        if let aN1 = (snapshot.value as? NSDictionary)?["abilityName1"] as? String, let aD1 = (snapshot.value as? NSDictionary)?["abilityDesc1"] as? String {
            abilityName1 = aN1
            abilityDesc1 = aD1
        }
        
        if let aN2 = (snapshot.value as? NSDictionary)?["abilityName2"] as? String, let aD2 = (snapshot.value as? NSDictionary)?["abilityDesc2"] as? String {
            abilityName2 = aN2
            abilityDesc2 = aD2
        }
        if let sN2 = (snapshot.value as? NSDictionary)?["skillName2"] as? String, let sM2 = (snapshot.value as? NSDictionary)?["skillMana2"] as? String, let sD2 = (snapshot.value as? NSDictionary)?["skillDesc2"] as? String {
            skillName2 = sN2
            skillMana2 = sM2
            skillDesc2 = sD2
        }
        
        if let sN3 = (snapshot.value as? NSDictionary)?["skillName3"] as? String, let sM3 = (snapshot.value as? NSDictionary)?["skillMana3"] as? String, let sD3 = (snapshot.value as? NSDictionary)?["skillDesc3"] as? String {
            skillName3 = sN3
            skillMana3 = sM3
            skillDesc3 = sD3
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

func ==(lhs: Arcana, rhs: Arcana) -> Bool {
    return lhs.uid == rhs.uid
}
struct ArcanaDictionary {
    var arcanaDictionary: [Arcana]?
}
