//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

struct Arcana {
    
    var uid: String?
    var name: String?
    var rarity: String?
    var group: String?  // Class, 직업
    var affiliation: String?
    var cost: String?
    var weapon: String?
    
    var kizunaName: String?
    var kizunaCost: String?
    var kizunaAbility: String?
    
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
    
    init?(n: String, r: String, g: String, a: String, c: String, w: String, kN: String, kC: String, kA: String, sN1: String, sM1: String, sD1: String, sN2: String, sM2: String, sD2: String, sN3: String, sM3: String, sD3: String, aN1: String, aD1: String, aN2: String, aD2: String) {
        name = n
        rarity = r
        group = g
        affiliation = a
        cost = c
        weapon = w
        
        kizunaName  = kN
        kizunaCost = kC
        kizunaAbility = kA
        
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
    }
    
}

struct ArcanaDictionary {
    var arcanaDictionary: [Arcana]?
}
