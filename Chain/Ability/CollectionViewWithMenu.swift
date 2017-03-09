//
//  AbilityListCollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class CollectionViewWithMenu: UIViewController {
    
    var menuBar = MenuBar()
    var selectedIndex: Int = 0
    var numberOfMenuTabs = 0
    var abilityType = ""
    var arcanaArray = [Arcana]()
    var currentArray = [Arcana]()
    var menuType: menuType?
    var reuseIdentifier = ""
    
    var datasource: AbilityViewDataSource?
    
    var primaryAbilities = [Ability]()
    var statusAbilities = [Ability]()
    var areaAbilities = [Ability]()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        collectionView.register(AbilityViewTableCell.self, forCellWithReuseIdentifier: "AbilityViewTableCell")
        collectionView.register(AbilityListTableCell.self, forCellWithReuseIdentifier: "AbilityListTableCell")
        collectionView.register(TavernListTableCell.self, forCellWithReuseIdentifier: "TavernListTableCell")
        
        return collectionView
        
    }()

    
    init() {
        super.init(nibName: nil, bundle: nil)
        menuType = .AbilityList
        self.numberOfMenuTabs = 2
        self.reuseIdentifier = "AbilityListTableCell"
        self.title = "어빌리티"
        
        menuBar = MenuBar(frame: .zero, menuType: .AbilityList)
        menuBar.parentController = self
    }
    
    init(abilityType: (String, String), selectedIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        menuType = .AbilityView
        self.abilityType = abilityType.1
        self.selectedIndex = selectedIndex
        downloadArray()
        self.numberOfMenuTabs = 5
        self.reuseIdentifier = "AbilityViewTableCell"
        self.title = abilityType.0
        menuBar = MenuBar(frame: .zero, menuType: .AbilityView)
        menuBar.parentController = self
        if abilityType.0 == "웨이브 회복" {
            setupNavBar()
        }
        
        
    }
    
    init(menuType: menuType) {
        super.init(nibName: nil, bundle: nil)
        
        // should be tavernView
        self.numberOfMenuTabs = 3
        self.menuType = menuType
        self.reuseIdentifier = "TavernListTableCell"
        self.title = "주점"
        
        menuBar = MenuBar(frame: .zero, menuType: menuType)
        menuBar.parentController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func downloadArray() {
        
        // check if ability or kizuna
        var refSuffix = ""
        
        if selectedIndex == 0 {
            refSuffix = "Ability"
        }
        else {
            refSuffix = "Kizuna"
        }
        
        // Then check ability type
        
        let refPrefix = abilityType
 
//        print("REF IS \(refPrefix)\(refSuffix)")
        var ref: FIRDatabaseReference
        let updatedVersion = "1.2"
        
        if let currentVersion = defaults.getStoredVersion() {
            if currentVersion.versionToInt().lexicographicallyPrecedes(updatedVersion.versionToInt()) {
                ref = FIREBASE_REF.child("\(refPrefix)\(refSuffix)")
            }
            else {
                ref = FIREBASE_REF.child("ability").child(refPrefix).child(refSuffix)
            }
        }
        else {
            ref = FIREBASE_REF.child("\(refPrefix)\(refSuffix)")
        }
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            var array = [Arcana]()
            
            let group = DispatchGroup()

            for id in uid {
                group.enter()
                
                let ref = FIREBASE_REF.child("arcana/\(id)")
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                    }
                    
                    group.leave()
                    
                })
                
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                
                self.arcanaArray = array
                self.currentArray = array
                self.datasource = AbilityViewDataSource(arcanaArray: array)

                self.collectionView.reloadData()
            })
            
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAbilityList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectedCV = IndexPath(item: selectedIndex, section: 0)
        guard let table = collectionView.cellForItem(at: selectedCV) as? BaseCollectionViewCell else { return }
        guard let selectedIndexPath = table.tableView.indexPathForSelectedRow else { return }
        table.tableView.deselectRow(at: selectedIndexPath, animated: true)

        
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(menuBar)
        view.addSubview(collectionView)
        
        menuBar.backgroundColor = .white
        menuBar.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        collectionView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 50, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    private func setupNavBar() {
        let filterButton = UIBarButtonItem(title: "전체", style: .plain, target: self, action: #selector(filter))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func setupAbilityList() {
        
        guard let menuType = menuType else { return }
        
        if menuType == .AbilityList {

            primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), APRecover(), Sub(), SkillUp(), AttackUp(), BossWave(), ManaSlot(), ManaChance(), PartyHeal()]
            
            statusAbilities = [DarkImmune(), DarkStrike(), SlowImmune(), SlowStrike(), PoisonImmune(), PoisonStrike(), CurseImmune(), CurseStrike(), SkeletonImmune(), SkeletonStrike(), StunImmune(), StunStrike(), FrostImmune(), FrostStrike(), SealImmune(), SealStrike()]

            areaAbilities = [WasteLand(), Forest(), Cavern(), Desert(), Snow(), Urban(), Water(), Night()]

            
            collectionView.reloadData()

        }

    }
    
    func filter() {
        
        
//        currentArray = self.arcanaArray.filter({$0.abilityDesc1?.contains("아군")})
        
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        selectedIndex = menuIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x)/CGFloat(numberOfMenuTabs) + CGFloat(10)
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        selectedIndex = indexPath.item
    }

    
    
}

extension CollectionViewWithMenu: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfMenuTabs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let menuType = menuType else { return UICollectionViewCell() }
        
        switch menuType {
        case .AbilityList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AbilityListTableCell
            cell.primaryAbilities = primaryAbilities
            cell.statusAbilities = statusAbilities
            cell.areaAbilities = areaAbilities
            cell.tableDelegate = self
            
            return cell
        case .AbilityView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AbilityViewTableCell
            cell.selectedIndex = self.selectedIndex
            cell.abilityType = abilityType
            cell.pageIndex = indexPath.row
            cell.tableDelegate = self
            if let datasource = datasource {
                cell.currentArray = datasource.getCurrentArray(index: indexPath.row)
            }
            
            cell.tag = indexPath.row
            return cell

        case .TavernList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TavernListTableCell
            cell.pageIndex = indexPath.row
            cell.tableDelegate = self
            return cell
        }
        
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    
    
    
}
