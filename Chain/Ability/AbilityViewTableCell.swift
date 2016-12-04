//
//  AbilityViewTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class AbilityViewTableCell: UICollectionViewCell {
    
    //    @IBOutlet weak var tableView: UITableView!
    var tableView = UITableView()
    
    var pageIndex: Int!
    var arcanaArray = [Arcana]()
    var currentArray = [Arcana]()
    var tableDelegate: AbilityCollectionView?
    let manaTypes = ["전사", "기사", "궁수", "법사", "승려"]
    var selectedIndex = 0
    var abilityType = "" {
        didSet {
            downloadArray()
        }
    }
    var group = DispatchGroup()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
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
            
            self.group.notify(queue: DispatchQueue.main, execute: {
                self.arcanaArray = array
                switch self.selectedIndex {
                case 0:
                    self.currentArray = self.arcanaArray.filter({$0.group == "전사"})
                case 1:
                    self.currentArray = self.arcanaArray.filter({$0.group == "기사"})
                case 2:
                    self.currentArray = self.arcanaArray.filter({$0.group == "궁수"})
                case 3:
                    self.currentArray = self.arcanaArray.filter({$0.group == "법사"})
                default:
                    self.currentArray = self.arcanaArray.filter({$0.group == "승려"})
                    
                }

                self.tableView.reloadData()
            })
            
            
        })
        
    }
    
    func setupTableView() {
        
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.sectionHeaderHeight = 1
        
    }

    
}


extension AbilityViewTableCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        vc.arcana = currentArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        
        tableDelegate?.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

