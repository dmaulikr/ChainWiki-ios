//
//  Filter.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol FilterDelegate : class {
    func didUpdate(_ sender: Filter)
}

class Filter: UIViewController {
    
    weak var delegate: FilterDelegate?

    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = Color.gray247
        
        collectionView.register(RarityCell.self, forCellWithReuseIdentifier: "RarityCell")
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        
        return collectionView
    }()
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 14.0, bottom: 10.0, right: 14.0)
    fileprivate let cellInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    fileprivate let cellSpacingInsets = CGFloat(4)
    fileprivate let numberOfCells = CGFloat(5)
    fileprivate var cellSize = CGFloat()
    fileprivate var cellSizeTavern = CGFloat()
    fileprivate var clearFilterSize = CGFloat()

    var hasFilter = false

    fileprivate let rarity = ["5", "4", "3", "2", "1"]
    fileprivate let group = ["전사", "기사","궁수","법사","승려"]
    fileprivate let weapon = ["검", "봉", "창", "마", "궁", "성", "권", "총", "저"]
    fileprivate let affiliation = ["여행자", "마신", "부도", "성도", "현탑", "미궁", "호도", "정령섬", "구령", "대해", "수인", "죄", "박명", "철연", "연대기", "레무", "의용군", "화격단"]
    
    var filterTypes = [String : [String]]()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    func setupViews() {
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
}

extension Filter : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Section: Int {
        
        case Rarity
        case Class
        case Weapon
        case Affiliation
        case Clear
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
            
        case .Rarity:
            return 5
        case .Class:
            return 5
        case .Weapon:
            return 9
        case .Affiliation:
            return affiliation.count
        case .Clear:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
            
        case .Rarity:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RarityCell", for: indexPath) as! RarityCell
            cell.rarityLabel.text = rarity[(indexPath as NSIndexPath).row]
            return cell
            
        case .Class:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.filterLabel.text = group[(indexPath as NSIndexPath).row]
            return cell
        case .Weapon:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.filterLabel.text = weapon[(indexPath as NSIndexPath).row]
            return cell
            
        case .Affiliation:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.filterLabel.text = affiliation[(indexPath as NSIndexPath).row]
            return cell
            
        case .Clear:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            cell.filterLabel.text = "필터 지우기"
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }

        // TODO: Add to filterTypes based on section
        // Hold an array to be updated after selection
        //        var filteredArray = [Arcana]()
        
        switch section {
            
        case .Rarity:
            let cell = collectionView.cellForItem(at: indexPath) as! RarityCell
            cell.cellAnimate()
            print("SELECTED RARITY \(cell.rarityLabel.text!)")
            
            var rarityArray = [String]()
            
            // If there is already another rarity selected
            if let rarityDict = filterTypes["rarity"] {
                rarityArray = rarityDict
            }
                
                // Else make a new one
            else {
                rarityArray = [String]()
            }
            
            rarityArray.append(cell.rarityLabel.text!)
            filterTypes.updateValue(rarityArray, forKey: "rarity")
            hasFilter = true
            
        case .Class:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            cell.cellAnimate()
            cell.isHighlighted = true
            print("SELECTED GROUP \(cell.filterLabel.text!)")
            
            var groupArray = [String]()
            
            if let groupDict = filterTypes["group"] {
                groupArray = groupDict
            }
            else {
                groupArray = [String]()
            }
            groupArray.append(cell.filterLabel.text!)
            filterTypes.updateValue(groupArray, forKey: "group")
            hasFilter = true
            
        case .Weapon:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            cell.cellAnimate()
            cell.isHighlighted = true
            print("SELECTED WEAPON \(cell.filterLabel.text!)")
            
            var weaponArray = [String]()
            
            if let weaponDict = filterTypes["weapon"] {
                weaponArray = weaponDict
            }
            else {
                weaponArray = [String]()
            }
            weaponArray.append(cell.filterLabel.text!)
            filterTypes.updateValue(weaponArray, forKey: "weapon")
            hasFilter = true
            
        case .Affiliation:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            cell.cellAnimate()
            cell.isHighlighted = true
            print("SELECTED AFFILIATION \(cell.filterLabel.text!)")
            
            var affiliationArray = [String]()
            
            if let affiliationDict = filterTypes["affiliation"] {
                affiliationArray = affiliationDict
            }
            else {
                affiliationArray = [String]()
            }
            
            affiliationArray.append(fullAffiliationName(affiliation: cell.filterLabel.text!))
            filterTypes.updateValue(affiliationArray, forKey: "affiliation")
            hasFilter = true
            
        case .Clear:
            
            if let selectedFilters = collectionView.indexPathsForSelectedItems {
                for i in selectedFilters {
                    collectionView.deselectItem(at: i, animated: true)
                    collectionView.cellForItem(at: i)?.isHighlighted = false
                }
                
                let clearArray = [String]()
                for (key, _) in filterTypes {
                    filterTypes.updateValue(clearArray, forKey: key)
                }
                hasFilter = false
            }
            
        }
        
        delegate!.didUpdate(self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {
            
        case .Rarity:
            let cell = collectionView.cellForItem(at: indexPath) as! RarityCell
            let deleteRarity = cell.rarityLabel.text!
            var rarityArray = filterTypes["rarity"]!
            for (index, filter) in rarityArray.enumerated().reversed() {
                if filter == deleteRarity {
                    rarityArray.remove(at: index)
                }
            }
            filterTypes.updateValue(rarityArray, forKey: "rarity")
            
        case .Class:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            let deleteGroup = cell.filterLabel.text!
            var groupArray = filterTypes["group"]!
            for (index, filter) in groupArray.enumerated().reversed() {
                if filter == deleteGroup {
                    groupArray.remove(at: index)
                }
            }
            filterTypes.updateValue(groupArray, forKey: "group")
            
        case .Weapon:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            let deleteWeapon = cell.filterLabel.text!
            var weaponArray = filterTypes["weapon"]!
            for (index, filter) in weaponArray.enumerated().reversed() {
                if filter == deleteWeapon {
                    weaponArray.remove(at: index)
                }
            }
            filterTypes.updateValue(weaponArray, forKey: "weapon")
            
        case .Affiliation:
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCell
            let deleteAffiliation = cell.filterLabel.text!
            var affiliationArray = filterTypes["affiliation"]!
            for (index, filter) in affiliationArray.enumerated().reversed() {
                if filter == fullAffiliationName(affiliation: deleteAffiliation) {
                    affiliationArray.remove(at: index)
                }
            }
            filterTypes.updateValue(affiliationArray, forKey: "affiliation")
            
        default:
            break
        }
        
        // Check if deselected last cell, meaning no filters selected
        if collectionView.indexPathsForSelectedItems!.count == 0 {
            if let _ = parent as? Home {
                hasFilter = false
            }
        }
        
        delegate?.didUpdate(self)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let section = Section(rawValue: indexPath.section) else { return CGSize() }

        cellSize = (collectionView.frame.width - (sectionInsets.left * 2 + cellSpacingInsets))/numberOfCells
        
        switch section {
            
        case .Rarity, .Class, .Weapon:
            return CGSize(width: cellSize, height: cellSize)
            
        case .Affiliation:
            cellSizeTavern = (view.frame.width - (sectionInsets.left * 2 + CGFloat(3)))/4
            return CGSize(width: cellSizeTavern, height: cellSize)
            
        case .Clear:
            clearFilterSize = view.frame.width - sectionInsets.left * 2
            return CGSize(width: clearFilterSize, height: cellSize)
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0: // This one needs higher top inset
            return sectionInsets
        default:
            return UIEdgeInsetsMake(5, 14, 5, 14)
        }
        

        
    }

}

