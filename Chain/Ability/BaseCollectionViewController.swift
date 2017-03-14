//
//  BaseCollectionViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class BaseCollectionViewController: UIViewController {

    weak var menuBarDelegate: MenuBarViewController?

    let menuType: MenuType
    var abilityMenu: AbilityMenu? = .ability
    var selectedIndex: Int = 0 {
        didSet {
            if menuType == .abilityList {
                if selectedIndex == 0 {
                    abilityMenu = .ability
                }
                else {
                    abilityMenu = .kizuna
                }
            }
        }
    }
    
    var primaryAbilities: [Ability]?
    var statusAbilities: [Ability]?
    var areaAbilities: [Ability]?
    
    var datasource: AbilityViewDataSource?
    var abilityType = ""
    var arcanaArray: [Arcana]?
    var currentArray: [Arcana]?
    
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
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        return collectionView
    }()
    
    init(menuType: MenuType) {
        self.menuType = menuType
        super.init(nibName: nil, bundle: nil)
    }
    
    init(abilityType: (String, String), abilityMenu: AbilityMenu) {
        menuType = .abilityView
        super.init(nibName: nil, bundle: nil)
        self.abilityType = abilityType.1
        self.abilityMenu = abilityMenu
        downloadArray()
//        if abilityType.0 == "웨이브 회복" {
//            setupNavBar()
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        switch menuType {
        case .abilityList:
            setupAbilityList()
        case .abilityView:
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: collectionView)
            }
        case .tavernList:
            downloadArray()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectedCV = IndexPath(item: selectedIndex, section: 0)
        guard let table = collectionView.cellForItem(at: selectedCV) as? BaseCollectionViewCell, let selectedIndexPath = table.tableView.indexPathForSelectedRow else { return }
        table.tableView.deselectRow(at: selectedIndexPath, animated: true)
        
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    private func setupNavBar() {
        let filterButton = UIBarButtonItem(title: "전체", style: .plain, target: self, action: #selector(filter))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func filter() {
        
        
    }
    
    func setupAbilityList() {
        
        primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), APRecover(), Sub(), SkillUp(), AttackUp(), BossWave(), ManaSlot(), ManaChance(), PartyHeal()]
        
        statusAbilities = [DarkImmune(), DarkStrike(), SlowImmune(), SlowStrike(), PoisonImmune(), PoisonStrike(), CurseImmune(), CurseStrike(), SkeletonImmune(), SkeletonStrike(), StunImmune(), StunStrike(), FrostImmune(), FrostStrike(), SealImmune(), SealStrike()]
        
        areaAbilities = [WasteLand(), Forest(), Cavern(), Desert(), Snow(), Urban(), Water(), Night()]
        
        collectionView.reloadData()
        
    }
    
    func downloadArray() {
        
        // check if ability or kizuna
        var refSuffix = ""
        
        if abilityMenu == .ability {
            refSuffix = "Ability"
        }
        else {
            refSuffix = "Kizuna"
        }
        
        // Then check ability type
        
        let refPrefix = abilityType
        
        var ref: FIRDatabaseReference
        let updatedVersion = "1.2"
        
        if let currentVersion = defaults.getStoredVersion() {
            if currentVersion.versionToInt().lexicographicallyPrecedes(updatedVersion.versionToInt()) {
                ref = FIREBASE_REF.child("\(refPrefix)\(refSuffix)")
            }
            else {
                ref = FIREBASE_REF.child("ability").child("\(refPrefix)\(refSuffix)")
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
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition())
            })
            
            
        })
        
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        selectedIndex = menuIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let numberOfMenuTabs = menuBarDelegate?.numberOfMenuTabs ?? 2
        menuBarDelegate?.menuBar.horizontalBarLeadingAnchorConstraint?.constant = (scrollView.contentOffset.x)/CGFloat(numberOfMenuTabs) + CGFloat(10)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBarDelegate?.menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        selectedIndex = indexPath.item
    }
    
}

extension BaseCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfMenuTabs = menuBarDelegate?.numberOfMenuTabs ?? 2
        return numberOfMenuTabs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch menuType {
        case .abilityList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AbilityListTableCell", for: indexPath) as! AbilityListTableCell
            
            if let primaryAbilities = primaryAbilities, let statusAbilities = statusAbilities, let areaAbilities = areaAbilities {
                cell.primaryAbilities = primaryAbilities
                cell.statusAbilities = statusAbilities
                cell.areaAbilities = areaAbilities
            }
            
            cell.collectionViewDelegate = self
            return cell
            
        case .abilityView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AbilityViewTableCell", for: indexPath) as! AbilityViewTableCell
            cell.collectionViewDelegate = self
            if let datasource = datasource {
                cell.currentArray = datasource.getCurrentArray(index: indexPath.row)
            }
            return cell
            
        case .tavernList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TavernListTableCell", for: indexPath) as! TavernListTableCell
            cell.pageIndex = indexPath.row
            cell.collectionViewDelegate = self
            return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

extension BaseCollectionViewController: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let cvIndexPath = collectionView.indexPathForItem(at: location) ?? IndexPath(item: 0, section: 0)
        guard let cvCell = collectionView.cellForItem(at: cvIndexPath) as? AbilityViewTableCell else { return nil }
        
        // Configure location to appropriate coordinates within the tableView
        let locationX = location.x - SCREENWIDTH * (CGFloat(selectedIndex))
        let locationY = location.y + cvCell.tableView.contentOffset.y

        let screenLocation = CGPoint(x: locationX, y: locationY)
        
        // Configure the peek source
        guard let indexPath = cvCell.tableView.indexPathForRow(at: screenLocation) else { return nil }
        previewingContext.sourceRect = cvCell.tableView.rectForRow(at: indexPath)
        
        // Peek the arcana
        let arcana = cvCell.currentArray[indexPath.row]
        
        let vc = ArcanaPeekPreview(arcana: arcana)
        vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)
        
        return vc
    }
    
}

