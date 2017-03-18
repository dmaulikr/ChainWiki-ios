//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

class ArcanaEdit {
    
    var uid: String
    var nameKR: String?
    var nicknameKR: String?
    var nameJP: String?
    var nicknameJP: String?
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
    
    var skillCount: String?
    
    var abilityName1: String?
    var abilityDesc1: String?
    
    var abilityName2: String?
    var abilityDesc2: String?
    
    var abilityName3: String?
    var abilityDesc3: String?
    
    var partyAbility: String?
    
    var dateAdded: String?
    var chainStory: String?
    var chainStone: String?

    func getUID() -> String {
        return uid
    }
    
    func getNameKR() -> String? {
        return nameKR
    }
    
    func getNicknameKR() -> String? {
        return nicknameKR
    }
    
    func getNameJP() -> String? {
        return nameJP
    }
    
    func getNicknameJP() -> String? {
        return nicknameJP
    }
    
    func getRarity() -> String? {
        return rarity
    }
    
    func getGroup() -> String? {
        return group
    }
    
    func getTavern() -> String? {
        return tavern
    }
    
    func getAffiliation() -> String? {
        return affiliation
    }
    
    func getCost() -> String? {
        return cost
    }
    
    func getWeapon() -> String? {
        return weapon
    }
    
    func getKizunaName() -> String? {
        return kizunaName
    }
    
    func getKizunaCost() -> String? {
        return kizunaCost
    }
    
    func getKizunaDesc() -> String? {
        return kizunaDesc
    }
    
    func getSkillCount() -> String? {
        return skillCount
    }
    
    func getSkillName1() -> String? {
        return skillName1
    }
    
    func getSkillMana1() -> String? {
        return skillMana1
    }
    
    func getSkillDesc1() -> String? {
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
    
    func getDateAdded() -> String? {
        return dateAdded
    }
    
    func getChainStory() -> String? {
        return chainStory
    }
    
    func getChainStone() -> String? {
        return chainStone
    }
    
    
    // Setters
    func setNameKR(_ nameKR: String) {
        self.nameKR = nameKR
    }
    
    func setNicknameKR(_ nicknameKR: String) {
        self.nicknameKR = nicknameKR
    }
    
    func setNameJP(_ nameJP: String) {
        self.nameJP = nameJP
    }
    
    func setNicknameJP(_ nicknameJP: String ) {
        self.nicknameJP = nicknameJP
    }
    
    func setRarity(_ rarity: String) {
        self.rarity = rarity
    }
    
    func setGroup(_ group: String) {
        self.group = group
    }
    
    func setTavern(_ tavern: String) {
        self.tavern = tavern
    }
    
    func setAffiliation(_ affiliation: String) {
        self.affiliation = affiliation
    }
    
    func setCost(_ cost: String) {
        self.cost = cost
    }
    
    func setWeapon(_ weapon: String) {
        self.weapon = weapon
    }
    
    func setKizunaName(_ kizunaName: String) {
        self.kizunaName = kizunaName
    }
    
    func setKizunaCost(_ kizunaCost: String) {
        self.kizunaCost = kizunaCost
    }
    
    func setKizunaDesc(_ kizunaDesc: String) {
        self.kizunaDesc = kizunaDesc
    }
    
    func setSkillCount(_ skillCount: String) {
        self.skillCount = skillCount
    }
    
    func setSkillName1(_ skillName1: String) {
        self.skillName1 = skillName1
    }
    
    func setSkillMana1(_ skillMana1: String) {
        self.skillMana1 = skillMana1
    }
    
    func setSkillDesc1(_ skillDesc1: String) {
        self.skillDesc1 = skillDesc1
    }
    
    func setSkillName2(_ skillName2: String) {
        self.skillName2 = skillName2
    }
    
    func setSkillMana2(_ skillMana2: String) {
        self.skillMana2 = skillMana2
    }
    
    func setSkillDesc2(_ skillDesc2: String) {
        self.skillDesc2 = skillDesc2
    }
    
    func setSkillName3(_ skillName3: String) {
        self.skillName3 = skillName3
    }
    
    func setSkillMana3(_ skillMana3: String) {
        self.skillMana3 = skillMana3
    }
    
    func setSkillDesc3(_ skillDesc3: String) {
        self.skillDesc3 = skillDesc3
    }
    
    func setAbilityName1(_ abilityName1: String) {
        self.abilityName1 = abilityName1
    }
    
    func setAbilityDesc1(_ abilityDesc1: String) {
        self.abilityDesc1 = abilityDesc1
    }
    
    func setAbilityName2(_ abilityName2: String) {
        self.abilityName2 = abilityName2
    }
    
    func setAbilityDesc2(_ abilityDesc2: String) {
        self.abilityDesc2 = skillName2
    }
    
    func setAbilityName3(_ abilityName3: String) {
        self.abilityName3 = abilityName3
    }
    
    func setAbilityDesc3(_ abilityDesc3: String) {
        self.abilityDesc3 = abilityDesc3
    }
    
    func setPartyAbility(_ partyAbility: String) {
        self.partyAbility = partyAbility
    }
    
    init(_ arcana: Arcana) {
        
        uid = arcana.getUID()
        nameKR = arcana.getNameKR()
        nicknameKR = arcana.getNicknameKR()
        nameJP = arcana.getNameJP()
        nicknameJP = arcana.getNicknameJP()
        rarity = arcana.getRarity()
        group = arcana.getGroup()
        tavern = arcana.getTavern()
        affiliation = arcana.getAffiliation()
        cost = arcana.getCost()
        weapon = arcana.getWeapon()

        kizunaName = arcana.getKizunaName()
        kizunaCost = arcana.getKizunaCost()
        kizunaDesc = arcana.getKizunaDesc()
        
        skillName1 = arcana.getSkillName1()
        skillMana1 = arcana.getSkillMana1()
        skillDesc1 = arcana.getSkillDesc1()
        
        skillName2 = arcana.getSkillName2()
        skillMana2 = arcana.getSkillMana2()
        skillDesc2 = arcana.getSkillDesc2()
        
        skillName3 = arcana.getSkillName3()
        skillMana3 = arcana.getSkillMana3()
        skillDesc3 = arcana.getSkillDesc3()
        
        abilityName1 = arcana.getAbilityName1()
        abilityDesc1 = arcana.getAbilityDesc1()
        
        abilityName2 = arcana.getAbilityName2()
        abilityDesc2 = arcana.getAbilityDesc2()
        
        partyAbility = arcana.getPartyAbility()
    }
    
    init(arcanaID: String, snapshot: FIRDataSnapshot) {
        
        uid = arcanaID
        
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
            nicknameKR = nnKR
        }
        
        if let nnJP = (snapshot.value as? NSDictionary)?["nickNameJP"] as? String {
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
        
        if let pA = (snapshot.value as? NSDictionary)?["partyAbility"] as? String {
            partyAbility = pA
        }

    }

}

