//
//  Weapon.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/8/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation

class Weapon {
    
    private let KR: String
    private let JP: String
    
    init(kr: String, jp: String) {
        self.KR = kr
        self.JP = jp
    }
    
    func getKR() -> String {
        return KR
    }
    
    func getJP() -> String {
        return JP
    }
    
    
}

class Sword: Weapon {
    init() {
        super.init(kr: "검", jp: "斬")
    }
}

class Blunt: Weapon {
    init() {
        super.init(kr: "봉", jp: "打")
    }
}

class Spear: Weapon {
    init() {
        super.init(kr: "창", jp: "突")
    }
}

class Bow: Weapon {
    init() {
        super.init(kr: "궁", jp: "弓")
    }
}

class Wand: Weapon {
    init() {
        super.init(kr: "마", jp: "魔")
    }
}

class Heal: Weapon {
    init() {
        super.init(kr: "성", jp: "聖")
    }
}

class Fist: Weapon {
    init() {
        super.init(kr: "권", jp: "拳")
    }
}

class Gun: Weapon {
    init() {
        super.init(kr: "총", jp: "銃")
    }
}

class Rifle: Weapon {
    init() {
        super.init(kr: "저", jp: "狙")
    }
}

func getWeaponJPKR(string: String) -> String {

    let weapons: [Weapon] = [Sword(), Blunt(), Spear(), Bow(), Wand(), Heal(), Fist(), Gun(), Rifle()]
    
    for w in weapons {
        if string.contains(w.getJP()) {
            return w.getKR()
        }
    }
    
    print("didn't find weapon")
    return "-"
    
}
