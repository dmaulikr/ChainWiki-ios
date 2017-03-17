//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

class Arcana: Equatable, Hashable {
    
    var uid: String
    var nameKR: String
    var nicknameKR: String?
    var nameJP: String
    var nicknameJP: String?
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
    
    var abilityName3: String?
    var abilityDesc3: String?
    
    var partyAbility: String?
    
    private var numberOfViews: Int
    private var dateAdded: String?
    private var chainStory: String?
    private var chainStone: String?
    private var numberOfLikes: Int
    
    var hashValue: Int {
        return uid.hashValue
    }

    init?(snapshot: FIRDataSnapshot) {

        guard let u = (snapshot.value as? NSDictionary)?["uid"] as? String, let nKR = (snapshot.value as? NSDictionary)?["nameKR"] as? String, let nJP = (snapshot.value as? NSDictionary)?["nameJP"] as? String, let r = (snapshot.value as? NSDictionary)?["rarity"] as? String, let g = (snapshot.value as? NSDictionary)?["class"] as? String, let t = (snapshot.value as? NSDictionary)?["tavern"] as? String, let a = (snapshot.value as? NSDictionary)?["affiliation"] as? String, let c = (snapshot.value as? NSDictionary)?["cost"] as? String, let w = (snapshot.value as? NSDictionary)?["weapon"] as? String, let kN = (snapshot.value as? NSDictionary)?["kizunaName"] as? String, let kC = (snapshot.value as? NSDictionary)?["kizunaCost"] as? String, let kD = (snapshot.value as? NSDictionary)?["kizunaDesc"] as? String, let sC = (snapshot.value as? NSDictionary)?["skillCount"] as? String, let sN1 = (snapshot.value as? NSDictionary)?["skillName1"] as? String, let sM1 = (snapshot.value as? NSDictionary)?["skillMana1"] as? String, let sD1 = (snapshot.value as? NSDictionary)?["skillDesc1"] as? String, let v = (snapshot.value as? NSDictionary)?["numberOfViews"] as? Int else {
                print("COULD NOT GET SNAPSHOT OF 1 SKILL ARCANA")
            print(snapshot.ref)
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
            numberOfLikes = (snapshot.value as? NSDictionary)?["numberOfLikes"] as? Int ?? 0

        if let nnKR = (snapshot.value as? NSDictionary)?["nicknameKR"] as? String {
            nicknameKR = nnKR
        }
        else if let nnKR = (snapshot.value as? NSDictionary)?["nickNameKR"] as? String {
            nicknameKR = nnKR
        }
        if let nnJP = (snapshot.value as? NSDictionary)?["nickameJP"] as? String {
            nicknameJP = nnJP
        }
        else if let nnJP = (snapshot.value as? NSDictionary)?["nickNameJP"] as? String {
            nicknameJP = nnJP
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
        
        if let sN2 = (snapshot.value as? NSDictionary)?["skillName2"] as? String {
            skillName2 = sN2
        }

        if let sM2 = (snapshot.value as? NSDictionary)?["skillMana2"] as? String {
            skillMana2 = sM2
        }
        
        if let sD2 = (snapshot.value as? NSDictionary)?["skillDesc2"] as? String {
            skillDesc2 = sD2
        }
        
        if let sN3 = (snapshot.value as? NSDictionary)?["skillName3"] as? String {
            skillName3 = sN3
        }

        if let sM3 = (snapshot.value as? NSDictionary)?["skillMana3"] as? String {
            skillMana3 = sM3
        }
        
        if let sD3 = (snapshot.value as? NSDictionary)?["skillDesc3"] as? String {
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
        
        if let pA = (snapshot.value as? NSDictionary)?["partyAbility"] as? String {
            partyAbility = pA
        }

        
  
    }
    
    func populateArray() -> [String] {
        
        let editKeys = ["nameKR", "nickNameKR", "nameJP", "nickNameJP", "skillName1", "skillMana1", "skillDesc1", "skillName2", "skillMana2", "skillDesc2", "skillName3", "skillMana3", "skillDesc3", "abilityName1", "abilityDesc1", "abilityName1", "abilityDesc1", "kizunaName", "kizunaCost", "kizunaDesc"]
        var arcanaDict = [String]()
        
        let arcana = self
        
        let mirrored_object = Mirror(reflecting: arcana)
        
        for att in mirrored_object.children {
            if let property_name = att.label as String! {
                if editKeys.contains(property_name) {
                    arcanaDict.append(att.value as? String ?? "")
                }
                
                
            }
        }
        
        return arcanaDict
        
    }
    
    func getUID() -> String {
        return uid
    }
    
    func getNameKR() -> String {
        return nameKR
    }
    
    func getNicknameKR() -> String? {
        return nicknameKR
    }
    
    func getNameJP() -> String {
        return nameJP
    }
    
    func getNicknameJP() -> String? {
        return nicknameJP
    }
    
    func getRarity() -> String {
        return rarity
    }
    
    func getGroup() -> String {
        return group
    }
    
    func getTavern() -> String {
        return tavern
    }
    
    func getAffiliation() -> String? {
        return affiliation
    }
    
    func getCost() -> String {
        return cost
    }
    
    func getWeapon() -> String {
        return weapon
    }
    
    func getKizunaName() -> String {
        return kizunaName
    }
    
    func getKizunaCost() -> String {
        return kizunaCost
    }
    
    func getKizunaDesc() -> String {
        return kizunaDesc
    }
    
    func getSkillCount() -> String {
        return skillCount
    }
    
    func getSkillName1() -> String {
        return skillName1
    }
    
    func getSkillMana1() -> String {
        return skillMana1
    }
    
    func getSkillDesc1() -> String {
        return skillDesc1
    }
    
    func getSkillName2() -> String? {
        return skillName2
    }
    
    func getSkillMana2() -> String? {
        return skillMana2
    }
    
    func getSkillDesc2() -> String? {
        return skillDesc2
    }
    
    func getSkillName3() -> String? {
        return skillDesc3
    }
    
    func getSkillMana3() -> String? {
        return skillMana3
    }
    
    func getSkillDesc3() -> String? {
        return skillDesc3
    }
    
    func getAbilityName1() -> String? {
        return abilityName1
    }
    
    func getAbilityDesc1() -> String? {
        return abilityDesc1
    }
    
    func getAbilityName2() -> String? {
        return abilityName2
    }
    
    func getAbilityDesc2() -> String? {
        return abilityDesc2
    }
    
    func getAbilityName3() -> String? {
        return abilityName3
    }
    
    func getAbilityDesc3() -> String? {
        return abilityDesc3
    }
    
    func getPartyAbility() -> String? {
        return partyAbility
    }
    
    func getNumberOfViews() -> Int {
        return numberOfViews
    }
    
    func getNumberOfLikes() -> Int {
        return numberOfLikes
    }
    
    func getDateAdded() -> String? {
        return dateAdded
    }
    
    func getChainStory() -> String? {
        return chainStory
    }
    
    func getChainStone() -> String? {
        return chainStone
    }
    
}

func ==(lhs: Arcana, rhs: Arcana) -> Bool {
    return lhs.uid == rhs.uid
}
