//
//  AbilityListDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class AbilityListDataSource: NSObject {
    
    let abilityArray = ["마나의 소양", "상자 획득", "AP 회복", "골드", "경험치", "서브시 증가", "마나 슬롯 속도", "마나 획득 확률 증가"]
    let kizunaArray = ["마나의 소양", "상자 획득", "골드", "경험치", "서브시 증가", "필살기 증가", "공격력 증가", "보스 웨이브시 공격력 증가", "어둠 면역", "슬로우 면역", "독 면역", "마나 슬롯 속도", "마나 획득 확률 증가"]
    
    let abilityImages = [#imageLiteral(resourceName: "mana"), #imageLiteral(resourceName: "treasure"), #imageLiteral(resourceName: "apRecovery"), #imageLiteral(resourceName: "gold"), #imageLiteral(resourceName: "exp"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "darknessImmune"), #imageLiteral(resourceName: "slowImmune"), #imageLiteral(resourceName: "poisonImmune"), #imageLiteral(resourceName: "manaSlot"), #imageLiteral(resourceName: "manaChance")]
    let kizunaImages = [#imageLiteral(resourceName: "mana"), #imageLiteral(resourceName: "treasure"), #imageLiteral(resourceName: "gold"), #imageLiteral(resourceName: "exp"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "darknessImmune"), #imageLiteral(resourceName: "slowImmune"), #imageLiteral(resourceName: "poisonImmune"), #imageLiteral(resourceName: "manaSlot"), #imageLiteral(resourceName: "manaChance")]
    
    func getAbilityList(index: Int) -> (titles: [String], images: [UIImage]) {
        
        if index == 0 {
            return (abilityArray, abilityImages)
        }
        else {
            return (kizunaArray, kizunaImages)
        }
      
        
    }
    
}
