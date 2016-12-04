//
//  AbilityViewDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 12/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation

class AbilityViewDataSource: NSObject {
    
    private var arcanaArray = [Arcana]()
    private var currentArray = [Arcana]()
    
    
    func getArcanaList(index: Int) -> (arcanaArray: [Arcana], currentArray: [Arcana]) {
        
        switch index {
            
        case 0: // 전사
            currentArray = arcanaArray.filter({$0.group == "전사"})
        case 1: // 기사
            currentArray = arcanaArray.filter({$0.group == "기사"})
        case 2: // 궁수
            currentArray = arcanaArray.filter({$0.group == "궁수"})
        case 3: // 법사
            currentArray = arcanaArray.filter({$0.group == "법사"})
        default:    // 승려
            currentArray = arcanaArray.filter({$0.group == "승려"})
            
        }
        return (arcanaArray,currentArray)
        
        
    }

}
