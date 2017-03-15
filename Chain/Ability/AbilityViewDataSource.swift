//
//  AbilityViewDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 12/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

enum classType {
    case Warriors
    case Knights
    case Archers
    case Magicians
    case Healers
}

class AbilityViewDataSource: NSObject {
    
    var selectedClass = classType.Warriors

    private var arcanaArray = [Arcana]()
    private var currentArray = [Arcana]()
    
    private var warriors = [Arcana]()
    private var knights = [Arcana]()
    private var archers = [Arcana]()
    private var magicians = [Arcana]()
    private var healers = [Arcana]()
    
    init(arcanaArray: [Arcana]) {
        super.init()
        self.arcanaArray = arcanaArray
        filterAbilityList()
        
    }
    
    init(index: Int) {
        super.init()
        
        switch index {
        case 0:
            self.selectedClass = .Warriors
            currentArray = warriors
        case 1:
            self.selectedClass = .Knights
            currentArray = knights
        case 2:
            self.selectedClass = .Archers
            currentArray = archers
        case 3:
            self.selectedClass = .Magicians
            currentArray = magicians
        default:
            self.selectedClass = .Healers
            currentArray = healers
            
        }
        
    }
    
    private func filterAbilityList() {
        
        warriors = arcanaArray.filter({$0.getGroup() == "전사"})
        
        // Process the other arrays in background.
        DispatchQueue.global().async {
            self.knights = self.arcanaArray.filter({$0.getGroup() == "기사"})
            self.archers = self.arcanaArray.filter({$0.getGroup() == "궁수"})
            self.magicians = self.arcanaArray.filter({$0.getGroup() == "법사"})
            self.healers = self.arcanaArray.filter({$0.getGroup() == "승려"})
        }
    
    }

    func getCurrentArray(index: Int) -> [Arcana] {
        
        switch index {
        case 0:
            self.selectedClass = .Warriors
            currentArray = warriors
        case 1:
            self.selectedClass = .Knights
            currentArray = knights
        case 2:
            self.selectedClass = .Archers
            currentArray = archers
        case 3:
            self.selectedClass = .Magicians
            currentArray = magicians
        default:
            self.selectedClass = .Healers
            currentArray = healers
            
        }
        return currentArray

    }
    
}
