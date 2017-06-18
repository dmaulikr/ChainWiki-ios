//
//  ArcanaUpload.swift
//  Chain
//
//  Created by Jitae Kim on 6/13/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

struct ArcanaUpload: Codable {
    
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

}
