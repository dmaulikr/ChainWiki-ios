//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

struct Arcana {
    
    var uid: String
    var nameKR: String
    var nameJP: String
    var rarity: String
    var group: String  // Class, 직업
    var tavern: String  // 주점
    var affiliation: String // 소속
    var cost: String
    var weapon: String

    var kizunaName: String
    var kizunaCost: String
    var kizunaAbility: String
    
    var skillCount : String
    
    var skillName1 : String
    var skillMana1 : String
    var skillDesc1 : String
    
    var skillName2 : String
    var skillMana2 : String
    var skillDesc2 : String
    
    var skillName3 : String?
    var skillMana3 : String?
    var skillDesc3 : String?
    
    var abilityName1: String
    var abilityDesc1: String
    
    var abilityName2: String
    var abilityDesc2: String
    
    var numberOfViews: Int
    
    
    init?(u: String, nKR: String, nJP: String, r: String, g: String, t: String, a: String, c: String, w: String, kN: String, kC: String, kA: String, sC: String, sN1: String, sM1: String, sD1: String, sN2: String, sM2: String, sD2: String, sN3: String, sM3: String, sD3: String, aN1: String, aD1: String, aN2: String, aD2: String, v: Int) {
        
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
        kizunaAbility = kA
        
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
        
        if let u = snapshot.value!["uid"] as? String, let nKR = snapshot.value!["nameKR"] as? String, let nJP = snapshot.value!["nameJP"] as? String, let r = snapshot.value!["rarity"] as? String, let g = snapshot.value!["class"] as? String, let t = snapshot.value!["tavern"] as? String, let a = snapshot.value!["affiliation"] as? String, let c = snapshot.value!["cost"] as? String, let w = snapshot.value!["weapon"] as? String, let kN = snapshot.value!["kizunaName"] as? String, let kC = snapshot.value!["kizunaCost"] as? String, let kA = snapshot.value!["kizunaAbility"] as? String, let sC = snapshot.value!["skillCount"] as? String, let sN1 = snapshot.value!["skillName1"] as? String, let sM1 = snapshot.value!["skillMana1"] as? String, let sD1 = snapshot.value!["skillDesc1"] as? String, let sN2 = snapshot.value!["skillName2"] as? String, let sM2 = snapshot.value!["skillMana2"] as? String, let sD2 = snapshot.value!["skillDesc2"] as? String, let sN3 = snapshot.value!["skillName3"] as? String, let sM3 = snapshot.value!["skillMana3"] as? String, let sD3 = snapshot.value!["skillDesc3"] as? String, let aN1 = snapshot.value!["abilityName1"] as? String, let aD1 = snapshot.value!["abilityDesc1"] as? String, let aN2 = snapshot.value!["abilityName2"] as? String, let aD2 = snapshot.value!["abilityDesc2"] as? String, let v = snapshot.value!["numberOfViews"] as? Int{

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
            kizunaAbility = kA
            
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
        
        else {
            print("SOMETHING WENT WRONG")
            return nil
        }
    }
    
}

struct ArcanaDictionary {
    var arcanaDictionary: [Arcana]?
}
