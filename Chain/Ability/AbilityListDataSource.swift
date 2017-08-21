//
//  AbilityListDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

struct AbilityArray {
    
    private let primary: [Ability]
    private let status: [Ability]
    private let area: [Ability]
    
    
    init(primary: [Ability], status: [Ability], area: [Ability]) {
        self.primary = primary
        self.status = status
        self.area = area
    }
    
    func getPrimary() -> [Ability] {
        return primary
    }
    
    func getStatus() -> [Ability] {
        return status
    }
    
    func getArea() -> [Ability] {
        return area
    }
    
}

class AbilityListDataSource {
    
    private var primaryAbilities: [Ability] = [Mana()]
    private var statusAbilities: [Ability]
    private var areaAbilities: [Ability]
    
    init() {

//        let a = Mana()
//        primaryAbilities = [a]
        primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), APRecover(), Sub(), SkillUp(), AttackUp(), BossWave(), ManaSlot(), ManaChance(), PartyHeal()]

        statusAbilities = [DarkImmune(), DarkStrike(), SlowImmune(), SlowStrike(), PoisonImmune(), PoisonStrike(), CurseImmune(), CurseStrike(), SkeletonImmune(), SkeletonStrike(), StunImmune(), StunStrike(), FrostImmune(), FrostStrike(), SealImmune(), SealStrike()]
        
        areaAbilities = [WasteLand(), Forest(), Cavern(), Desert(), Snow(), Urban(), Water(), Night()]
        
    }
    
    func getPrimary() -> [Ability] {
        return primaryAbilities
    }
    
    func getStatus() -> [Ability] {
        return statusAbilities
    }
    
    func getArea() -> [Ability] {
        return areaAbilities
    }
    
//    func getAbilityList() -> AbilityArray {
//    
//        let abilityArray = AbilityArray(primary: primaryAbilities, status: statusAbilities, area: areaAbilities)
//
//        return abilityArray
//
//    }

}
