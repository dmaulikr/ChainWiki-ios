//
//  AbilityListDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class AbilityListDataSource: NSObject {
    
    private var primaryAbilities: [Unowned<Ability>]
    private var statusAbilities: [Unowned<Ability>]
    private var areaAbilities: [Unowned<Ability>]
    
    
    override init() {
        
        primaryAbilities = [Unowned(Mana()), Unowned(Treasure()), Unowned(Gold()), Unowned(Experience()), Unowned(APRecover()), Unowned(Sub()), Unowned(SkillUp()), Unowned(AttackUp()), Unowned(BossWave()), Unowned(ManaSlot()), Unowned(ManaChance()), Unowned(PartyHeal())]

        statusAbilities = [Unowned(DarkImmune()), Unowned(DarkStrike()), Unowned(SlowImmune()), Unowned(SlowStrike()), Unowned(PoisonImmune()), Unowned(PoisonStrike()), Unowned(CurseImmune()), Unowned(CurseStrike()), Unowned(SkeletonImmune()), Unowned(SkeletonStrike()), Unowned(StunImmune()), Unowned(StunStrike()), Unowned(FrostImmune()), Unowned(FrostStrike()), Unowned(SealImmune()), Unowned(SealStrike())]
        
        areaAbilities = [Unowned(WasteLand()), Unowned(Forest()), Unowned(Cavern()), Unowned(Desert()), Unowned(Snow()), Unowned(Urban()), Unowned(Water()), Unowned(Night())]
        
        super.init()
    }
    
    func getAbilityList() -> AbilityArray {
        

//        let abilityArray = AbilityArray(primary: primaryAbilities, status: statusAbilities, area: areaAbilities)
        
        return AbilityArray(primary: primaryAbilities, status: statusAbilities, area: areaAbilities)
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
        primaryAbilities = []
        statusAbilities = []
        areaAbilities = []
    }
    
}
