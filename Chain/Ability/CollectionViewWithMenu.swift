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
    var collectionView: UICollectionView!
    var arcanaArray = [Arcana]()
    var currentArray = [Arcana]()
    var menuType: menuType?
    var reuseIdentifier = ""
    var datasource: AbilityViewDataSource!

    
    var group = DispatchGroup()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        menuType = .AbilityList
        self.numberOfMenuTabs = 2
        self.reuseIdentifier = "AbilityListTableCell"
        setupMenuBar()
    }
    
    init(abilityType: String, selectedIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        menuType = .AbilityView
        self.abilityType = abilityType
        self.selectedIndex = selectedIndex
        downloadArray()
        self.numberOfMenuTabs = 5
        self.reuseIdentifier = "AbilityViewTableCell"
        setupMenuBar()
        
    }
    
    init(menuType: menuType) {
        super.init(nibName: nil, bundle: nil)
        
        // should be tavernView
        self.numberOfMenuTabs = 3
        self.menuType = menuType
        self.reuseIdentifier = "TavernListTableCell"
        setupMenuBar()
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
        
        //["마나의 소양", "상자 획득", "골드", "경험치", "서브시 증가", "필살기 증가", "공격력 증가", "보스 웨이브시 공격력 증가"]
        var refPrefix = ""
        
        switch abilityType {
            
        case "마나의 소양":
            refPrefix = "mana"
        case "마나 슬롯 속도":
            refPrefix = "manaSlot"
        case "마나 획득 확률 증가":
            refPrefix = "manaChance"
        case "상자 획득":
            refPrefix = "treasure"
        case "AP 회복":
            refPrefix = "apRecover"
        case "골드":
            refPrefix = "gold"
        case "경험치":
            refPrefix = "exp"
        case "서브시 증가":
            refPrefix = "sub"
        case "필살기 증가":
            refPrefix = "skillUp"
        case "공격력 증가":
            refPrefix = "attackUp"
        case "보스 웨이브시 공격력 증가":
            refPrefix = "bossWave"
        case "어둠 면역":
            refPrefix = "darkImmune"
        case "슬로우 면역":
            refPrefix = "slowImmune"
        case "독 면역":
            refPrefix = "poisonImmune"
            
        default:
            break
            
        }
        
        //        print("REF IS \(refPrefix)\(refSuffix)")
        let ref = FIREBASE_REF.child("\(refPrefix)\(refSuffix)")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            var array = [Arcana]()
            
            for id in uid {
                self.group.enter()
                
                let ref = FIREBASE_REF.child("arcana/\(id)")
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                    }
                    
                    self.group.leave()
                    
                })
                
            }
            
            self.group.notify(queue: DispatchQueue.main, execute: { [unowned self] in
                
                self.arcanaArray = array
                self.datasource = AbilityViewDataSource(arcanaArray: array)

                self.collectionView.reloadData()
            })
            
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = .white
        self.title = abilityType

        setupCollectionView()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let selectedCV = IndexPath(item: selectedIndex, section: 0)        
        let table = collectionView.cellForItem(at: selectedCV) as! BaseCollectionViewCell
        guard let selectedIndexPath = table.tableView.indexPathForSelectedRow else { return }
        table.tableView.deselectRow(at: selectedIndexPath, animated: true)

        
    }
    
    private func setupMenuBar() {
        
        guard let menuType = menuType else { return }
        
        menuBar = MenuBar(frame: .zero, menuType: menuType)
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        menuBar.backgroundColor = .white
        menuBar.parentController = self
    }
    
    // MARK: UICollectionViewDataSource
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.register(AbilityViewTableCell.self, forCellWithReuseIdentifier: "AbilityViewTableCell")
        collectionView.register(AbilityListTableCell.self, forCellWithReuseIdentifier: "AbilityListTableCell")
        collectionView.register(TavernListTableCell.self, forCellWithReuseIdentifier: "TavernListTableCell")
        
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        self.selectedIndex = menuIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x)/CGFloat(numberOfMenuTabs) + CGFloat(10)
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        self.selectedIndex = indexPath.item
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
            
            let list = AbilityListDataSource().getAbilityList(index: indexPath.row)
            cell.abilityNames = list.titles
            cell.abilityImages = list.images
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
