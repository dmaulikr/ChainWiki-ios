
//
//  TavernHomeView.swift
//  Chain
//
//  Created by Jitae Kim on 9/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Favorites: UIViewController {
    
    var array = [Arcana]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")

        return tableView
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "아르카나를 추가하세요!"
        label.textColor = .darkGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.alpha = 0
        return label
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editFavorites))
        return button
    }()
    
    lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(openSettings))
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadFavorites()
        guard let row = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: row, animated: true)
        
    }

    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(tipLabel)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tipLabel.anchorCenterSuperview()
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton

    }
    
    func setupNavBar() {
        
        navigationItem.title = "즐겨찾기"
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = editButton

    }
    
    func openSettings() {
        
        let vc = Settings()
        navigationController?.pushViewController(vc, animated: true)
    }

    func editFavorites() {
        
        if array.count != 0 {
            
            tableViewSetEditing()
            
            if !tableView.isEditing {
                // set userDefaults to new array.
                var favoritesDict = [String: Int]()
                var uids = [String]()
                for (index, arcana) in array.enumerated() {
                    favoritesDict.updateValue(index, forKey: arcana.getUID())
                    uids.append(arcana.getUID())
                    
                }
                
                let userFavorites = defaults.getFavorites()
                
                if uids != userFavorites {
                    // made changes, upload to firebase
                    if let id = defaults.getUID() {
                        let ref = FIREBASE_REF.child("user/\(id)/favorites")
                        ref.setValue(favoritesDict)
                        
                        defaults.setFavorites(value: uids)
                    }
                }

            }
            
        }
        
    }
    
    func tableViewSetEditing() {
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "수정"
        }
        else {
            tableView.setEditing(true, animated: true)
            editButton.title = "완료"
        }
    }
    
    func downloadFavorites() {
        
        let userFavorites = defaults.getFavorites()
        
        var uids = [String]()
        
        for id in userFavorites {
            let arcanaID = id
            uids.append(arcanaID)
        }
        
        var array = [Arcana]()
        
        let group = DispatchGroup()
        
        for id in uids {
            group.enter()
            
            let ref = FIREBASE_REF.child("arcana/\(id)")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                let arcana = Arcana(snapshot: snapshot)
                array.append(arcana!)
                group.leave()
                
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            
            self.array = array
            self.tableView.reloadData()
        })

    }
    
    
}


extension Favorites: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if array.count == 0 {
            tableView.alpha = 0
            tipLabel.fadeIn(withDuration: 0.5)
            
        }
        else {
            tipLabel.fadeOut(withDuration: 0.2)
            tableView.fadeIn(withDuration: 0.5)
        }
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        
        
        for i in cell.labelCollection {
            i.text = nil
        }
        
        cell.arcanaImage.image = nil
        
        //        cell.imageSpinner.startAnimating()
        
        let arcana = array[indexPath.row]
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.getNicknameKR() {
            cell.arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.getNicknameJP() {
            
            cell.arcanaNickJP.text = nnJP
            
        }
        cell.arcanaNameKR.text = arcana.getNameKR()
        cell.arcanaNameJP.text = arcana.getNameJP()
        
        cell.arcanaRarity.text = "#\(arcana.getRarity())★"
        cell.arcanaGroup.text = "#\(arcana.getGroup())"
        cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
        if let a = arcana.getAffiliation() {
            if a != "" {
                cell.arcanaAffiliation.text = "#\(a)"
            }
            
        }
        
        cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
        cell.arcanaUID = arcana.getUID()
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/icon.jpg") {
            
            cell.arcanaImage.image = i
            //            cell.imageSpinner.stopAnimating()
            print("LOADED FROM CACHE")
            
        }
            
        else {
            FirebaseService.dataRequest.downloadImage(uid: arcana.getUID(), sender: cell)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let arcana = array[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.setEditing(editing, animated: animated)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = array[sourceIndexPath.row]
        array.remove(at: sourceIndexPath.row)
        array.insert(itemToMove, at: destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            // delete item at indexPath
            let idToRemove = self.array[indexPath.row].uid
            self.array.remove(at: indexPath.row)
            
            var userFavorites = defaults.getFavorites()
            
            for (index, i) in userFavorites.enumerated() {
                print("INDEX is \(index)")
                // not even checking here 2nd time.
                if i == idToRemove {
                    userFavorites.remove(at: index)
                    if let id = defaults.getUID() {
                        let ref = FIREBASE_REF.child("user/\(id)/favorites/\(i)")
                        ref.removeValue()
                        defaults.setFavorites(value: userFavorites)
                    }
                    
                    break
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        return [delete]
    }
    
}


