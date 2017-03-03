//
//  Ability.swift
//  Chain
//
//  Created by Jitae Kim on 12/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

class Ability {
    
    private let KR: String
    private let EN: String
    private let image: UIImage
    
    init(kr: String, en: String, img: UIImage) {
        self.KR = kr
        self.EN = en
        self.image = img
    }
    
    func getKR() -> String {
        return KR
    }
    
    func getEN() -> String {
        return EN
    }
    
    func getImage() -> UIImage {
        return image
    }
}

class AbilityArray {
    
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
class Mana: Ability {
    init() {
        super.init(kr: "마나의 소양", en: "mana", img: #imageLiteral(resourceName: "mana"))
    }
}

class ManaSlot: Ability {
    init() {
        super.init(kr: "마나 슬롯 속도", en: "manaSlot", img: #imageLiteral(resourceName: "manaSlot"))
    }
}

class ManaChance: Ability {
    init() {
        super.init(kr: "마나 획득 확률 증가", en: "manaChance", img: #imageLiteral(resourceName: "manaChance"))
    }
}

class Gold: Ability {
    init() {
        super.init(kr: "골드", en: "gold", img: #imageLiteral(resourceName: "gold"))
    }
}

class Experience: Ability {
    init() {
        super.init(kr: "경험치", en: "exp", img: #imageLiteral(resourceName: "exp"))
    }
}

class APRecover: Ability {
    init() {
        super.init(kr: "AP 회복", en: "apRecover", img: #imageLiteral(resourceName: "apRecovery"))
    }
}

class Treasure: Ability {
    init() {
        super.init(kr: "상자 획득", en: "treasure", img: #imageLiteral(resourceName: "treasure"))
    }
}

class Sub: Ability {
    init() {
        super.init(kr: "서브시 증가", en: "sub", img: #imageLiteral(resourceName: "support"))
    }
}

class SkillUp: Ability {
    init() {
        super.init(kr: "필살기 증가", en: "skillUp", img: #imageLiteral(resourceName: "skillUp"))
    }
}

class AttackUp: Ability {
    init() {
        super.init(kr: "공격력 증가", en: "attackUp", img: #imageLiteral(resourceName: "skillUp"))
    }
}

class BossWave: Ability {
    init() {
        super.init(kr: "보스 웨이브시 공격력 증가", en: "bossWave", img: #imageLiteral(resourceName: "boss"))
    }
}

class PartyHeal: Ability {
    init() {
        super.init(kr: "웨이브 회복", en: "partyHeal", img: #imageLiteral(resourceName: "apRecovery"))
    }
}
// 상태 이상 부여

class DarkStrike: Ability {
    init() {
        super.init(kr: "어둠 부여", en: "darkTouch", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class SlowStrike: Ability {
    init() {
        super.init(kr: "슬로우 부여", en: "slowStrike", img: #imageLiteral(resourceName: "slowImmune"))
    }
}

class PoisonStrike: Ability {
    init() {
        super.init(kr: "독 부여", en: "poisonStrike", img: #imageLiteral(resourceName: "poisonImmune"))
    }
}

class CurseStrike: Ability {
    init() {
        super.init(kr: "저주 부여", en: "curseStrike", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class SkeletonStrike: Ability {
    init() {
        super.init(kr: "쇠약 부여", en: "skeletonStrike", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class StunStrike: Ability {
    init() {
        super.init(kr: "다운 부여", en: "stunStrike", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class FrostStrike: Ability {
    init() {
        super.init(kr: "동결 부여", en: "frostStrike", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class SealStrike: Ability {
    init() {
        super.init(kr: "봉인 부여", en: "sealStrike", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

// 상태 이상 면역

class DarkImmune: Ability {
    init() {
        super.init(kr: "어둠 면역", en: "darkImmune", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class SlowImmune: Ability {
    init() {
        super.init(kr: "슬로우 면역", en: "slowImmune", img: #imageLiteral(resourceName: "slowImmune"))
    }
}

class PoisonImmune: Ability {
    init() {
        super.init(kr: "독 면역", en: "poisonImmune", img: #imageLiteral(resourceName: "poisonImmune"))
    }
}

class CurseImmune: Ability {
    init() {
        super.init(kr: "저주 면역", en: "curseImmune", img: #imageLiteral(resourceName: "poisonImmune"))
    }
}

class WeakImmune: Ability {
    init() {
        super.init(kr: "쇠약 면역", en: "weakImmune", img: #imageLiteral(resourceName: "skeleton"))
    }
}

class SkeletonImmune: Ability {
    init() {
        super.init(kr: "백골 면역", en: "skeletonImmune", img: #imageLiteral(resourceName: "skeleton"))
    }
}

class StunImmune: Ability {
    init() {
        super.init(kr: "다운 면역", en: "stunImmune", img: #imageLiteral(resourceName: "stun"))
    }
}

class FrostImmune: Ability {
    init() {
        super.init(kr: "동결 면역", en: "frostImmune", img: #imageLiteral(resourceName: "frost"))
    }
}

class SealImmune: Ability {
    init() {
        super.init(kr: "봉인 면역", en: "sealImmune", img: #imageLiteral(resourceName: "seal"))
    }
}

// 지형 특효
class WasteLand: Ability {
    init() {
        super.init(kr: "황무지 특효", en: "wastelands", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class Forest: Ability {
    init() {
        super.init(kr: "숲 특효", en: "forest", img: #imageLiteral(resourceName: "forest"))
    }
}

class Cavern: Ability {
    init() {
        super.init(kr: "덩굴 특효", en: "cavern", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class Desert: Ability {
    init() {
        super.init(kr: "사막 특효", en: "desert", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class Snow: Ability {
    init() {
        super.init(kr: "설산 특효", en: "snow", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class Urban: Ability {
    init() {
        super.init(kr: "도시 특효", en: "urban", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class Water: Ability {
    init() {
        super.init(kr: "해변 특효", en: "water", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

class Night: Ability {
    init() {
        super.init(kr: "야간 특효", en: "night", img: #imageLiteral(resourceName: "darknessImmune"))
    }
}

// 종족 특효

class Insect: Ability {
    
    private let attackKR = "공격력 증가"
    private let defenseKR = "방어력 증가"
    
    init() {
        super.init(kr: "벌레 특효", en: "insect", img: #imageLiteral(resourceName: "darknessImmune"))
    }
    
    func getAttack() -> String {
        return attackKR
    }
    
    func getDefense() -> String {
        return defenseKR
    }
}

