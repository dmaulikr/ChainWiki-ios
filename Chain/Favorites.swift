
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tip: UILabel!
    var group = DispatchGroup()
    var array = [Arcana]()
    @IBOutlet weak var edit: UIBarButtonItem!
    @IBAction func settings(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Settings") as! Settings
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func startEditing(_ sender: AnyObject) {
        
        if array.count != 0 {
            if !tableView.isEditing {
                tableView.setEditing(true, animated: true)
                edit.title = "완료"
            }
            else {
                tableView.setEditing(false, animated: true)
                // set userDefaults to new array.
                var favoritesDict = [String: Int]()
                var uids = [String]()
                for (index, arcana) in array.enumerated() {
                    favoritesDict.updateValue(index, forKey: arcana.uid)
                    uids.append(arcana.uid)
                    
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
                edit.title = "수정"
                
                
            }

        }
        
        else {
            // user deleted last row.
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
                edit.title = "수정"
            }
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
        
        for id in uids {
            self.group.enter()
            
            let ref = FIREBASE_REF.child("arcana/\(id)")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                let arcana = Arcana(snapshot: snapshot)
                array.append(arcana!)
                self.group.leave()
                
            })
        }
        
        self.group.notify(queue: DispatchQueue.main, execute: {
            
            self.array = array
            self.tableView.reloadData()
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadFavorites()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension Favorites: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if array.count == 0 {
            tableView.alpha = 0
            tip.fadeIn(withDuration: 0.5)
            
        }
        else {
            tip.fadeOut(withDuration: 0.2)
            tableView.alpha = 1
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
        
        
        cell.arcanaImage.image = nil
        
        //        cell.imageSpinner.startAnimating()
        
        let arcana = array[indexPath.row]
        
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
            //            cell.imageSpinner.stopAnimating()
            print("LOADED FROM CACHE")
            
        }
            
        else {
            FirebaseService.dataRequest.downloadImage(uid: arcana.uid, sender: cell)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let arcanaDetail = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        arcanaDetail.arcana = array[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        self.navigationController?.pushViewController(arcanaDetail, animated: true)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.setEditing(editing, animated: animated)
        self.tableView.endUpdates()
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
