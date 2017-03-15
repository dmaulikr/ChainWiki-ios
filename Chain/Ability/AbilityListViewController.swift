//
//  AbilityListViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListViewController: MenuBarViewController {

    var primaryAbilities = [Ability]()
    var statusAbilities = [Ability]()
    var areaAbilities = [Ability]()
    var raceAbilities = [Ability]()
    
    init() {
        super.init(menuType: .abilityList)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAbilityList()
    }

    func setupAbilityList() {

        primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), APRecover(), Sub(), SkillUp(), BossWave(), ManaSlot(), ManaChance(), PartyHeal()]
        
        statusAbilities = [DarkImmune(), DarkStrike(), SlowImmune(), SlowStrike(), PoisonImmune(), PoisonStrike(), CurseImmune(), CurseStrike(), SkeletonImmune(), SkeletonStrike(), StunImmune(), StunStrike(), FrostImmune(), FrostStrike(), SealImmune(), SealStrike()]
        
        areaAbilities = [WasteLand(), Forest(), Cavern(), Desert(), Snow(), Urban(), Water(), Night()]
        
        
        childViewController?.collectionView.reloadData()
        
    }

}
