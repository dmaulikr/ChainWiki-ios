//
//  Filter.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class Filter: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
    private let cellInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    var hasFilter = false
    
    let rarity = ["5★", "4★", "3★", "2★", "1★"]
    let group = ["전사", "기사","궁수","법사","승려"]
    let weapon = ["검", "봉", "창", "마", "궁", "성", "권", "총", "저"]
    let affiliation = ["여행자", "마신", "부도", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "구령", "대해", "수인", "죄", "박명", "철연", "연대기", "서가", "레무레스", "의용군", "화격단"]
    
    var filterTypes = [String : [String]]()
    /*
 case "副都":
 return "부도"
 case "聖都":
 return "성도"
 case "賢者の塔":
 return "현자의탑"
 case "迷宮山脈":
 return "미궁산맥"
 case "砂漠の湖都":
 return "호수도시"
 case "精霊島":
 return "정령섬"
 case "炎の九領":
 return "화염구령"
 case "大海":
 return "대해"
 case "ケ者の大陸":
 return "개들의대륙"
 case "罪の大陸":
 return "죄의대륙"
 case "薄命の大陸":
 return "박명의대륙"
 case "鉄煙の大陸":
 return "철연의대륙"
 case "年代記の大陸":
 return "연대기의대륙"
 case "レムレス島":
 return "레무레스섬"
 case "魔神":
 return "마신"
 case "旅人":
 return "여행자"
 case "義勇軍":
 return "의용군"
 */

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
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

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0: // Rarity
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = rarity[indexPath.row]
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = darkNavyColor.CGColor
            cell.contentView.layer.cornerRadius = 5
            return cell
            
        case 1:    // Class
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = group[indexPath.row]
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = darkNavyColor.CGColor
            cell.contentView.layer.cornerRadius = 5
            return cell
            
        case 2:    // Weapon
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = weapon[indexPath.row]
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = darkNavyColor.CGColor
            cell.contentView.layer.cornerRadius = 5
            return cell
            
        default:    // Affiliation
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = affiliation[indexPath.row]
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = darkNavyColor.CGColor
            cell.contentView.layer.cornerRadius = 5
            return cell
        }
        
    }
    
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        //
//    }
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
        cell.highlighted = true
        
        // TODO: Add to filterTypes based on section
        
        switch indexPath.section {
            
        case 0:
            print("SELECTED RARITY \(cell.filterType.text!)")
            
            var rarityArray = [String]()
            
            // If there is already another rarity selected
            if let rarityDict = filterTypes["rarity"] {
                rarityArray = rarityDict
            }
                
            // Else make a new one
            else {
                rarityArray = [String]()
            }
            
            rarityArray.append(cell.filterType.text!)
            filterTypes.updateValue(rarityArray, forKey: "rarity")
            print(filterTypes["rarity"]!)
        case 1:
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
        
        hasFilter = true

        
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell

        switch indexPath.section {
            
        case 0:
            let deleteRarity = cell.filterType.text!
            var rarityArray = filterTypes["rarity"]!
            for (index, rarity) in rarityArray.enumerate().reverse() {
                if rarity == deleteRarity {
                    print("DELETED \(deleteRarity)")
                    rarityArray.removeAtIndex(index)
                }
            }
            filterTypes.updateValue(rarityArray, forKey: "rarity")
        case 1:
            let deleteGroup = cell.filterType.text!
            var groupArray = filterTypes["group"]!
            for (index, rarity) in groupArray.enumerate().reverse() {
                if rarity == deleteGroup {
                    print("DELETED \(deleteGroup)")
                    groupArray.removeAtIndex(index)
                }
            }
            filterTypes.updateValue(groupArray, forKey: "group")
        case 2:
            let deleteWeapon = cell.filterType.text!
            var weaponArray = filterTypes["weapon"]!
            for (index, rarity) in weaponArray.enumerate().reverse() {
                if rarity == deleteWeapon {
                    print("DELETED \(deleteWeapon)")
                    weaponArray.removeAtIndex(index)
                }
            }
            filterTypes.updateValue(weaponArray, forKey: "weapon")
        default:
            let deleteAffiliation = cell.filterType.text!
            var affiliationArray = filterTypes["affiliation"]!
            for (index, rarity) in affiliationArray.enumerate().reverse() {
                if rarity == deleteAffiliation {
                    print("DELETED \(deleteAffiliation)")
                    affiliationArray.removeAtIndex(index)
                }
            }
            filterTypes.updateValue(affiliationArray, forKey: "affiliation")
        }
        
        // Check if deselected last cell, meaning no filters selected
        if let list = collectionView.indexPathsForSelectedItems() {
            if list.count == 0 {
                hasFilter = false
            }
    
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("CHANGED VIEW")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Filter : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: (SCREENWIDTH-24)/5, height: SCREENWIDTH / 10)
        case 1:
            return CGSize(width: (SCREENWIDTH-24)/5, height: SCREENWIDTH / 10)
        case 2:
            return CGSize(width: (SCREENWIDTH-28)/5, height: SCREENWIDTH / 10)
        default:
            return CGSize(width: (SCREENWIDTH-24)/4, height: SCREENWIDTH / 10)

            
        }
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    

}
