//
//  Ability.swift
//  Chain
//
//  Created by Jitae Kim on 12/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

class Unowned<T: AnyObject> {
    unowned var value: T
    init (_ value: T) {
        self.value = value
    }
}

class Ability {
    
    private let KR: String
    private let EN: String
    
    init(kr: String, en: String) {
        self.KR = kr
        self.EN = en
    }
    
    func getKR() -> String {
        return KR
    }
    
    func getEN() -> String {
        return EN
    }
    
    deinit {
        print("\(EN) has been deinited")
    }
}

class AbilityArray {
    
    private let primary: [Unowned<Ability>]
    private let status: [Unowned<Ability>]
    private let area: [Unowned<Ability>]
    
    
    init(primary: [Unowned<Ability>], status: [Unowned<Ability>], area: [Unowned<Ability>]) {
        self.primary = primary
        self.status = status
        self.area = area
    }
    
    func getPrimary() -> [Unowned<Ability>] {
        return primary
    }
    
    func getStatus() -> [Unowned<Ability>] {
        return status
    }
    
    func getArea() -> [Unowned<Ability>] {
        return area
    }
    
    deinit {
        print("abilityArray is deinited")
    }
    
}
class Mana: Ability {
    init() {
        super.init(kr: "마나의 소양", en: "mana")
    }
}

class ManaSlot: Ability {
    init() {
        super.init(kr: "마나 슬롯 속도", en: "manaSlot")
    }
}

class ManaChance: Ability {
    init() {
        super.init(kr: "마나 획득 확률 증가", en: "manaChance")
    }
}

class Gold: Ability {
    init() {
        super.init(kr: "골드", en: "gold")
    }
}

class Experience: Ability {
    init() {
        super.init(kr: "경험치", en: "exp")
    }
}

class APRecover: Ability {
    init() {
        super.init(kr: "AP 회복", en: "apRecover")
    }
}

class Treasure: Ability {
    init() {
        super.init(kr: "상자 획득", en: "treasure")
    }
}

class Sub: Ability {
    init() {
        super.init(kr: "서브시 증가", en: "sub")
    }
}

class SkillUp: Ability {
    init() {
        super.init(kr: "필살기 증가", en: "skillUp")
    }
}

class AttackUp: Ability {
    init() {
        super.init(kr: "공격력 증가", en: "attackUp")
    }
}

class BossWave: Ability {
    init() {
        super.init(kr: "보스 웨이브시 공격력 증가", en: "bossWave")
    }
}

class PartyHeal: Ability {
    init() {
        super.init(kr: "웨이브 회복", en: "partyHeal")
    }
}
// 상태 이상 부여

class DarkStrike: Ability {
    init() {
        super.init(kr: "어둠 부여", en: "darkTouch")
    }
}

class SlowStrike: Ability {
    init() {
        super.init(kr: "슬로우 부여", en: "slowStrike")
    }
}

class PoisonStrike: Ability {
    init() {
        super.init(kr: "독 부여", en: "poisonStrike")
    }
}

class CurseStrike: Ability {
    init() {
        super.init(kr: "저주 부여", en: "curseStrike")
    }
}

class SkeletonStrike: Ability {
    init() {
        super.init(kr: "쇠약 부여", en: "skeletonStrike")
    }
}

class StunStrike: Ability {
    init() {
        super.init(kr: "다운 부여", en: "stunStrike")
    }
}

class FrostStrike: Ability {
    init() {
        super.init(kr: "동결 부여", en: "frostStrike")
    }
}

class SealStrike: Ability {
    init() {
        super.init(kr: "봉인 부여", en: "sealStrike")
    }
}

// 상태 이상 면역

class DarkImmune: Ability {
    init() {
        super.init(kr: "어둠 면역", en: "darkImmune")
    }
}

class SlowImmune: Ability {
    init() {
        super.init(kr: "슬로우 면역", en: "slowImmune")
    }
}

class PoisonImmune: Ability {
    init() {
        super.init(kr: "독 면역", en: "poisonImmune")
    }
}

class CurseImmune: Ability {
    init() {
        super.init(kr: "저주 면역", en: "curseImmune")
    }
}

class WeakImmune: Ability {
    init() {
        super.init(kr: "쇠약 면역", en: "weakImmune")
    }
}

class SkeletonImmune: Ability {
    init() {
        super.init(kr: "백골 면역", en: "skeletonImmune")
    }
}

class StunImmune: Ability {
    init() {
        super.init(kr: "다운 면역", en: "stunImmune")
    }
}

class FrostImmune: Ability {
    init() {
        super.init(kr: "동결 면역", en: "frostImmune")
    }
}

class SealImmune: Ability {
    init() {
        super.init(kr: "봉인 면역", en: "sealImmune")
    }
}

// 지형 특효
class WasteLand: Ability {
    init() {
        super.init(kr: "황무지 특효", en: "wastelands")
    }
}

class Forest: Ability {
    init() {
        super.init(kr: "숲 특효", en: "forest")
    }
}

class Cavern: Ability {
    init() {
        super.init(kr: "덩굴 특효", en: "cavern")
    }
}

class Desert: Ability {
    init() {
        super.init(kr: "사막 특효", en: "desert")
    }
}

class Snow: Ability {
    init() {
        super.init(kr: "설산 특효", en: "snow")
    }
}

class Urban: Ability {
    init() {
        super.init(kr: "도시 특효", en: "urban")
    }
}

class Water: Ability {
    init() {
        super.init(kr: "해변 특효", en: "water")
    }
}

class Night: Ability {
    init() {
        super.init(kr: "야간 특효", en: "night")
    }
}

// 종족 특효

class Insect: Ability {
    
    private let attackKR = "공격력 증가"
    private let defenseKR = "방어력 증가"
    
    init() {
        super.init(kr: "벌레 특효", en: "insect")
    }
    
    func getAttack() -> String {
        return attackKR
    }
    
    func getDefense() -> String {
        return defenseKR
    }
}

