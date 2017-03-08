//
//  AbilityListDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListDataSource: NSObject {
    
    private var primaryAbilities: [Ability]
    private var statusAbilities: [Ability]
    private var areaAbilities: [Ability]
    
    override init() {

        primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), APRecover(), Sub(), SkillUp(), AttackUp(), BossWave(), ManaSlot(), ManaChance(), PartyHeal()]

        statusAbilities = [DarkImmune(), DarkStrike(), SlowImmune(), SlowStrike(), PoisonImmune(), PoisonStrike(), CurseImmune(), CurseStrike(), SkeletonImmune(), SkeletonStrike(), StunImmune(), StunStrike(), FrostImmune(), FrostStrike(), SealImmune(), SealStrike()]
        
        areaAbilities = [WasteLand(), Forest(), Cavern(), Desert(), Snow(), Urban(), Water(), Night()]
        
        super.init()
    }
    
    func getAbilityList() -> AbilityArray {
    
        let abilityArray = AbilityArray(primary: primaryAbilities, status: statusAbilities, area: areaAbilities)

        return abilityArray

    }

}
