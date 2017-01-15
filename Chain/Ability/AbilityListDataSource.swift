//
//  AbilityListDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class AbilityListDataSource: NSObject {
    
    private let primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), Sub(), SkillUp(), AttackUp(), BossWave(), ManaSlot(), ManaChance()]
    
    private let statusAbilities = [DarkImmune(), DarkStrike(), SlowImmune(), SlowStrike(), PoisonImmune(), PoisonStrike(), CurseImmune(), CurseStrike(), SkeletonImmune(), SkeletonStrike(), StunImmune(), StunStrike(), FrostImmune(), FrostStrike(), SealImmune(), SealStrike()]
    
    private let areaAbilities = [WasteLand(), Forest(), Cavern(), Desert(), Snow(), Urban(), Water(), Night()]
    
    func getAbilityList() -> AbilityArray {
        

        let abilityArray = AbilityArray(primary: primaryAbilities, status: statusAbilities, area: areaAbilities)
        
        return abilityArray
        //        if index == 0 {
        //            return (abilityArray, abilityImages)
        //        }
        //        else {
        //            return (kizunaArray, kizunaImages)
        //        }
        
        
    }
//    func getAbilityList(index: Int) -> (names: [String], images: [UIImage]) {
//        
//        var abilityNames = [String]()
//        var abilityImages = [UIImage]()
//        
//        for ability in abilityArray {
//            abilityNames.append(ability.getKR())
//            abilityImages.append(ability.getImage())
//        }
//        
//        return (abilityNames, abilityImages)
////        if index == 0 {
////            return (abilityArray, abilityImages)
////        }
////        else {
////            return (kizunaArray, kizunaImages)
////        }
//      
//        
//    }
    
    deinit {
        print("AbilityListDataSource has been deinited.")
        
    }
    
}
