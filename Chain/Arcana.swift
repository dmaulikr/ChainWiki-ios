//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

struct Arcana {
    var name: String?
    var rarity: String?
    var group: String?
    var weapon: String?
    var affiliation: String?
    
    init?(n: String, r: String) {
        name = n
        
        rarity = r
    }
    
}

struct ArcanaDictionary {
    var arcanaDictionary: [Arcana]?
}
