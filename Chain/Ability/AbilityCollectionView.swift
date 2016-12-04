//
//  AbilityCollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 11/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "abilityViewTableCell"

class AbilityCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let menuBar = MenuBar(frame: .zero, sections: 5)
    var selectedIndex: Int = 0
    let numberOfSections = 5
    var abilityType = ""
    var collectionView: UICollectionView!
    var arcanaArray = [Arcana]()
    var currentArray = [Arcana]()
    
    var warriors = [Arcana]()
    var knights = [Arcana]()
    var archers = [Arcana]()
    var magicians = [Arcana]()
    var healers = [Arcana]()
    
    var group = DispatchGroup()
    
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
                self.warriors = self.arcanaArray.filter({$0.group == "전사"})
                self.knights = self.arcanaArray.filter({$0.group == "기사"})
                self.archers = self.arcanaArray.filter({$0.group == "궁수"})
                self.magicians = self.arcanaArray.filter({$0.group == "법사"})
                self.healers = self.arcanaArray.filter({$0.group == "승려"})
                self.collectionView.reloadData()
            })
            
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = abilityType
        downloadArray()
        setupMenuBar()
        setupCollectionView()
        
    }


    private func setupMenuBar() {
        
        menuBar.numberOfSections = numberOfSections
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        menuBar.backgroundColor = .white
//        menuBar.homeController = self
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
        collectionView.register(AbilityViewTableCell.self, forCellWithReuseIdentifier: "abilityViewTableCell")
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AbilityViewTableCell
        cell.selectedIndex = indexPath.row
        cell.abilityType = abilityType
        cell.tableDelegate = self
//        switch indexPath.row {
//        case 0:
//            cell.currentArray = self.arcanaArray.filter({$0.group == "전사"})
//        case 1:
//            cell.currentArray = self.arcanaArray.filter({$0.group == "기사"})
//        case 2:
//            cell.currentArray = self.arcanaArray.filter({$0.group == "궁수"})
//        case 3:
//            cell.currentArray = self.arcanaArray.filter({$0.group == "법사"})
//        default:
//            cell.currentArray = self.arcanaArray.filter({$0.group == "승려"})
//        }
//        print(cell.currentArray.count)
//        cell.tableView.reloadData()
        cell.tag = indexPath.row
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

extension AbilityCollectionView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        var currentArray = [Arcana]()
        
        switch indexPath.row {
        case 0:
            currentArray = self.warriors
        case 1:
            currentArray = self.knights
        case 2:
            currentArray = self.archers
        case 3:
            currentArray = self.magicians
        default:
            currentArray = self.healers
        }
        
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
        print(self.currentArray.count)
        
        return cell
    }
}
