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
class AbilityViewDataSource: NSObject, UITableViewDataSource {
    
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
        
//        dispatch
        warriors = arcanaArray.filter({$0.group == "전사"})
        DispatchQueue.global().async { [unowned self] in
            self.knights = self.arcanaArray.filter({$0.group == "기사"})
            self.archers = self.arcanaArray.filter({$0.group == "궁수"})
            self.magicians = self.arcanaArray.filter({$0.group == "법사"})
            self.healers = self.arcanaArray.filter({$0.group == "승려"})
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
//        switch classType {
//            
//        case .Warriors:
//            return warriors
//        case .Knights:
//            return knights
//        case .Archers:
//            return archers
//        case .Magicians:
//            return magicians
//        case .Healers:
//            return healers
//            
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        if currentArray.count != 0 {
            
        }
        for i in cell.labelCollection {
            i.text = nil
        }
        cell.arcanaImage.image = nil
        
        //        cell.imageSpinner.startAnimating()
        
        let arcana = currentArray[indexPath.row]
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.nickNameKR {
            cell.arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.nickNameJP {
            
            cell.arcanaNickJP.text = nnJP
            
        }
        cell.arcanaNameKR.text = arcana.nameKR
        cell.arcanaNameJP.text = arcana.nameJP
        
        cell.arcanaRarity.text = "#\(arcana.rarity)★"
        cell.arcanaGroup.text = "#\(arcana.group)"
        cell.arcanaWeapon.text = "#\(arcana.weapon)"
        if let a = arcana.affiliation {
            if a != "" {
                cell.arcanaAffiliation.text = "#\(a)"
            }
            
        }
        
        cell.numberOfViews.text = "조회 \(arcana.numberOfViews)"
        cell.arcanaUID = arcana.uid
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg") {
            
            cell.arcanaImage.image = i
            print("LOADED FROM CACHE")
            
        }
            
        else {
            FirebaseService.dataRequest.downloadImage(uid: arcana.uid, sender: cell)
        }
        
        
        return cell
    }
}
