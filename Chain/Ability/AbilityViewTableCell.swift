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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        //        dataSource = AbilityViewDataSource(index: pageIndex)
        tableView.dataSource = self
        
        tableView.reloadData()
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
        return tableView

    }()
    var dataSource:AbilityViewDataSource!
    var pageIndex = 0
    var arcanaArray = [Arcana]()
    var currentArray = [Arcana]() {
        didSet {
            tableView.reloadData()
            
        }
    }
    var tableDelegate: CollectionViewWithMenu?
    var selectedIndex = 0
    var abilityType = ""
    var group = DispatchGroup()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableView() {
        
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        tableView.reloadData()
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

