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
    var updatedSize: CGSize!
    
    let menuType: MenuType
    var abilityMenu: AbilityMenu = .ability
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
    var currentArray: [Arcana]?
    var showAbilityPreview = defaults.getPreviewAbility() {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
 
        Analytics.logEvent("SelectedAbility", parameters: [
            "AbilityType": "\(abilityType.0) \(abilityMenu.rawValue)" as NSObject
            ])
        
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
            break
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updatedSize = view.frame.size
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectedCV = IndexPath(item: selectedIndex, section: 0)
        if let table = collectionView.cellForItem(at: selectedCV) as? BaseCollectionViewCell, let selectedIndexPath = table.tableView.indexPathForSelectedRow {
            table.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        if let iPadSecondTable = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? BaseCollectionViewCell, let selectedIndexPath = iPadSecondTable.tableView.indexPathForSelectedRow {
            iPadSecondTable.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        if let iPadThirdTable = collectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as? BaseCollectionViewCell, let selectedIndexPath = iPadThirdTable.tableView.indexPathForSelectedRow {
            iPadThirdTable.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let backButton = UIBarButtonItem(title: "어빌", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.horizontalSizeClass == .regular && menuType != .abilityView {
            menuBarDelegate?.menuBar?.horizontalBarView.alpha = 0
        }
        else {
            menuBarDelegate?.menuBar?.horizontalBarView.alpha = 1
        }
    }

    func setupAbilityList() {
        
        primaryAbilities = [Mana(), Treasure(), Gold(), Experience(), APRecover(), Sub(), SkillUp(), BossWave(), ManaSlot(), ManaChance(), PartyHeal()]
        
        statusAbilities = [DarkAttackUp(), DarkImmune(), DarkStrike(), SlowAttackUp(), SlowImmune(), SlowStrike(), PoisonAttackUp(), PoisonImmune(), PoisonStrike(), CurseAttackUp(), CurseImmune(), CurseStrike(), SkeletonAttackUp(), SkeletonImmune(), SkeletonStrike(), StunAttackUp(), StunImmune(), StunStrike(), FrostAttackUp(), FrostImmune(), FrostStrike(), SealAttackUp(), SealImmune(), SealStrike()]
        
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
        
        let ref = FIREBASE_REF.child("ability").child("\(refPrefix)\(refSuffix)")
        
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
                
                let ref = FIREBASE_REF.child("arcana").child(id)
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                    }
                    
                    group.leave()
                    
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                
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
        
        if traitCollection.horizontalSizeClass == .regular && menuType != .abilityView {
            
            let numberOfMenuTabs = menuBarDelegate?.numberOfMenuTabs ?? 2
            switch selectedIndex {
            case 0:
                self.menuBarDelegate?.menuBar.horizontalBarLeadingAnchorConstraint?.constant = 10
            default:
                self.menuBarDelegate?.menuBar.horizontalBarLeadingAnchorConstraint?.constant = (view.frame.width/CGFloat(numberOfMenuTabs)) * CGFloat(selectedIndex) + CGFloat(10)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.menuBarDelegate?.menuBar.layoutIfNeeded()
            })

        }
    }
    
    @objc
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
            if indexPath.row == 0 {
                cell.abilityMenu = .ability
            }
            else {
                cell.abilityMenu = .kizuna
            }
            cell.collectionViewDelegate = self
            return cell
            
        case .abilityView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AbilityViewTableCell", for: indexPath) as! AbilityViewTableCell
            cell.collectionViewDelegate = self
            cell.showAbilityPreview = showAbilityPreview
            cell.abilityMenu = abilityMenu
            
            if let datasource = datasource {
                cell.arcanaArray = datasource.getCurrentArray(index: indexPath.row)
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
        
        if updatedSize == nil {
            updatedSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }        
        
        switch menuType {
            
        case .abilityList:
            
            if traitCollection.horizontalSizeClass == .regular {
                return CGSize(width: updatedSize.width / 2, height: updatedSize.height)
            }
            
        case .abilityView:
            if view.frame.width == 1366 {
                return CGSize(width: updatedSize.width / 5, height: updatedSize.height)
            }
            break
            
        case .tavernList:
            if traitCollection.horizontalSizeClass == .regular {
                return CGSize(width: updatedSize.width / 3, height: updatedSize.height)
            }
        }
        
        return updatedSize
    }
    
}

extension BaseCollectionViewController: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        menuBarDelegate?.navigationController?.pushViewController(viewControllerToCommit, animated: true)
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
        let arcana = cvCell.arcanaArray[indexPath.section]
        
        let vc = ArcanaPeekPreview(arcana: arcana)
        vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)
        
        return vc
    }
    
}

