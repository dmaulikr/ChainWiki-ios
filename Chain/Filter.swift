//
//  Filter.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Canvas

class Filter: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let cellInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    var hasFilter = false
    var home = Home()
    
    let rarity = ["5", "4", "3", "2", "1"]
    let group = ["전사", "기사","궁수","법사","승려"]
    let weapon = ["검", "봉", "창", "마", "궁", "성", "권", "총", "저"]
    let affiliation = ["여행자", "마신", "부도", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "구령", "대해", "수인", "죄", "박명", "철연", "연대기", "서가", "레무레스", "의용군", "화격단"]
    
    var filterTypes = [String : [String]]()
    
    let cellSize = CGSize(width: (SCREENWIDTH-95-4-28)/5, height: (SCREENWIDTH-95-4-28)/5)
    let affCellSize = CGSize(width: (SCREENWIDTH-95-3-28)/4, height: (SCREENWIDTH-95-4-28)/5)

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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rarityCell", forIndexPath: indexPath) as! RarityCell
            cell.rarity.text = rarity[indexPath.row]
            
//            cell.layer.shadowColor = UIColor.grayColor().CGColor;
//            cell.layer.shadowOffset = CGSizeMake(0, 0.5);
//            cell.layer.shadowRadius = 1.0;
//            cell.layer.shadowOpacity = 1.0;
//            cell.layer.masksToBounds = false;
            return cell
            
        case 1:    // Class
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = group[indexPath.row]
            return cell
        case 2:    // Weapon
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = weapon[indexPath.row]
            return cell
            
        default:    // Affiliation
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = affiliation[indexPath.row]
            return cell
        }
        
    }
    
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = lightGreenColor
//        cell.selectedBackgroundView = backgroundView
//
//    }
//    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        // TODO: Add to filterTypes based on section
        // Hold an array to be updated after selection
        var filteredArray = [Arcana]()
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RarityCell
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
            
            home.arcanaArray = home.originalArray.filter({$0.rarity == 
        case 1:
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
            cell.highlighted = true
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
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
            cell.highlighted = true
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
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
            cell.highlighted = true
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
        

        switch indexPath.section {
            
        case 0:
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! RarityCell
            let deleteRarity = cell.rarity.text!
            var rarityArray = filterTypes["rarity"]!
            for (index, rarity) in rarityArray.enumerate().reverse() {
                if rarity == deleteRarity {
                    print("DELETED \(deleteRarity)")
                    rarityArray.removeAtIndex(index)
                }
            }
            filterTypes.updateValue(rarityArray, forKey: "rarity")
        case 1:
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
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
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
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
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FilterCell
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
        //self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: "border", withReuseIdentifier: "border")

        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        //panGesture!.isLeft(view) // returns true or false
        print("OPENED FILTER")
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
        // 414
        switch indexPath.section {
        case 0,1,2:
            return CGSize(width: (SCREENWIDTH-95-4-28)/5, height: (SCREENWIDTH-95-4-28)/5)
            //return CGSize(width: 50, height: 50)
        default:
            return CGSize(width: (SCREENWIDTH-95-3-28)/4, height: (SCREENWIDTH-95-4-28)/5)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        var count = 0
        var totalCellWidth = 0
        var totalSpacingWidth = 0
        switch section {
        case 0,1,2:
            count = 5
            totalCellWidth = Int(cellSize.width) * count
            totalSpacingWidth = 1 * (count - 1)
        default:
            count = 4
            totalCellWidth = Int(affCellSize.width) * count
            totalSpacingWidth = 1 * (count - 1)
            
        }
        
        
        
        let leftInset = (SCREENWIDTH - 95 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2;
        let rightInset = leftInset
        
        switch section {
        case 0: // This one needs higher top inset
            return UIEdgeInsetsMake(14, 14, 7, 14)
        default:
            return UIEdgeInsetsMake(7, 14, 7, 14)
        }
        

        
    }
    
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let border = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "border", forIndexPath: indexPath) as! MySupplementaryView
//        if kind == "border" {
//            print("HEY")
//        }
//        border.frame.size = CGSize(width: 100,height: 100)
//        border.backgroundColor = UIColor.blackColor()
//        
//        return border
//        
//    }
    
//     func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject] {
//    }
    

}

//extension Filter: UIGestureRecognizerDelegate {
//    // MARK: Gesture recognizer
//    
//    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
//        
//        
//    }
//    
//}