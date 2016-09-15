//
//  Filter.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Canvas

protocol FilterDelegate : class {
    func didUpdate(_ sender: Filter)
}

class Filter: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    weak var delegate: FilterDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let cellInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    var hasFilter = false
    var array = [Arcana]()

    let rarity = ["5", "4", "3", "2", "1"]
    let group = ["전사", "기사","궁수","법사","승려"]
    let weapon = ["검", "봉", "창", "마", "궁", "성", "권", "총", "저"]
    let affiliation = ["여행자", "마신", "부도", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "구령", "대해", "수인", "죄", "박명", "철연", "연대기", "서가", "레무레스", "의용군", "화격단"]
    
    var filterTypes = [String : [String]]()
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        switch section {
 
        case 0: // Rarity
            return 5
        case 1: // Class
            return 5
        case 2: // Weapon
            return 9
        default:    // Affiliation?
            return affiliation.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (indexPath as NSIndexPath).section {
            
        case 0: // Rarity
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rarityCell", for: indexPath) as! RarityCell
            cell.rarity.text = rarity[(indexPath as NSIndexPath).row]
            
            return cell
            
        case 1:    // Class
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filter", for: indexPath) as! FilterCell
            cell.filterType.text = group[(indexPath as NSIndexPath).row]
            return cell
        case 2:    // Weapon
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filter", for: indexPath) as! FilterCell
            cell.filterType.text = weapon[(indexPath as NSIndexPath).row]
            return cell
            
        default:    // Affiliation
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filter", for: indexPath) as! FilterCell
            cell.filterType.text = affiliation[(indexPath as NSIndexPath).row]
            return cell
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        // TODO: Add to filterTypes based on section
        // Hold an array to be updated after selection
//        var filteredArray = [Arcana]()
        
        switch (indexPath as NSIndexPath).section {
            
        case 0:
            let cell = collectionView.cellForItem(at: indexPath) as! RarityCell
            print("SELECTED RARITY \(cell.rarity.text!)")
            
            var rarityArray = [String]()
            
            // If there is already another rarity selected
            if let rarityDict = filterTypes["rarity"] {
                rarityArray = rarityDict
            }
                
            // Else make a new one
            else {
                rarityArray = [String]()
            }
            
            rarityArray.append(cell.rarity.text!)
            filterTypes.updateValue(rarityArray, forKey: "rarity")
            print(filterTypes["rarity"]!)
            
//            if let vc = parentViewController as? HomeContainerView {
//                print("SELECT ACCESSED HOME")
//                let home = vc.childViewControllers[0] as! Home
//                home.arcanaArray = home.arcanaArray.filter({$0.rarity == cell.rarity.text})
//            }


        case 1:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            cell.isHighlighted = true
            print("SELECTED GROUP \(cell.filterType.text!)")

            var groupArray = [String]()
            
            if let groupDict = filterTypes["group"] {
                groupArray = groupDict
            }
            else {
                groupArray = [String]()
            }
            groupArray.append(cell.filterType.text!)
            filterTypes.updateValue(groupArray, forKey: "group")
        case 2:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            cell.isHighlighted = true
            print("SELECTED WEAPON \(cell.filterType.text!)")
            
            var weaponArray = [String]()
            
            if let weaponDict = filterTypes["weapon"] {
                weaponArray = weaponDict
            }
            else {
                weaponArray = [String]()
            }
            weaponArray.append(cell.filterType.text!)
            filterTypes.updateValue(weaponArray, forKey: "weapon")
        default:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            cell.isHighlighted = true
            print("SELECTED AFFILIATION \(cell.filterType.text!)")
            
            var affiliationArray = [String]()
            
            if let affiliationDict = filterTypes["affiliation"] {
                affiliationArray = affiliationDict
            }
            else {
                affiliationArray = [String]()
            }
            affiliationArray.append(cell.filterType.text!)
            filterTypes.updateValue(affiliationArray, forKey: "affiliation")

        }
        self.delegate!.didUpdate(self)

        hasFilter = true

        
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        

        switch (indexPath as NSIndexPath).section {
            
        case 0:
            let cell = collectionView.cellForItem(at: indexPath) as! RarityCell
            let deleteRarity = cell.rarity.text!
            var rarityArray = filterTypes["rarity"]!
            for (index, rarity) in rarityArray.enumerated().reversed() {
                if rarity == deleteRarity {
                    print("DELETED \(deleteRarity)")
                    rarityArray.remove(at: index)
                }
            }
            filterTypes.updateValue(rarityArray, forKey: "rarity")
        case 1:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            let deleteGroup = cell.filterType.text!
            var groupArray = filterTypes["group"]!
            for (index, rarity) in groupArray.enumerated().reversed() {
                if rarity == deleteGroup {
                    print("DELETED \(deleteGroup)")
                    groupArray.remove(at: index)
                }
            }
            filterTypes.updateValue(groupArray, forKey: "group")
        case 2:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            let deleteWeapon = cell.filterType.text!
            var weaponArray = filterTypes["weapon"]!
            for (index, rarity) in weaponArray.enumerated().reversed() {
                if rarity == deleteWeapon {
                    print("DELETED \(deleteWeapon)")
                    weaponArray.remove(at: index)
                }
            }
            filterTypes.updateValue(weaponArray, forKey: "weapon")
        default:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            let deleteAffiliation = cell.filterType.text!
            var affiliationArray = filterTypes["affiliation"]!
            for (index, rarity) in affiliationArray.enumerated().reversed() {
                if rarity == deleteAffiliation {
                    print("DELETED \(deleteAffiliation)")
                    affiliationArray.remove(at: index)
                }
            }
            filterTypes.updateValue(affiliationArray, forKey: "affiliation")
        }
        
        // Check if deselected last cell, meaning no filters selected
        print("DESELECTED COUNT \(collectionView.indexPathsForSelectedItems)")
        if collectionView.indexPathsForSelectedItems!.count == 0 {
            if let vc = parent as? HomeContainerView {
                let home = vc.childViewControllers[0] as! Home
                home.arcanaArray = home.originalArray
                hasFilter = false
            }
        }

        self.delegate!.didUpdate(self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("CHANGED VIEW")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


extension Filter : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 414
       let inset = CGFloat(127)
        switch (indexPath as NSIndexPath).section {
        case 0,1,2:
            return CGSize(width: (SCREENWIDTH-inset)/5, height: (SCREENWIDTH-inset)/5)
            
        default:
            return CGSize(width: (SCREENWIDTH-inset)/4, height: (SCREENWIDTH-inset)/5)
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = CGFloat(127)
        let cellSize = CGSize(width: (SCREENWIDTH-inset)/5, height: (SCREENWIDTH-inset)/5)
        let affCellSize = CGSize(width: (SCREENWIDTH-inset)/4, height: (SCREENWIDTH-inset)/5)

        var count = CGFloat(0)
        var totalCellWidth = CGFloat(0)
        var totalSpacingWidth = CGFloat(0)
        switch section {
        case 0,1,2:
            count = CGFloat(5)
            totalCellWidth = cellSize.width * count
            totalSpacingWidth = (count - 1)
        default:
            count = CGFloat(4)
            totalCellWidth = affCellSize.width * count
            totalSpacingWidth = (count - 1)
            
        }
        
        
        switch section {
        case 0: // This one needs higher top inset
            return UIEdgeInsetsMake(14, 14, 7, 14)
        default:
            return UIEdgeInsetsMake(7, 14, 7, 14)
        }
        

        
    }
    

    

}


