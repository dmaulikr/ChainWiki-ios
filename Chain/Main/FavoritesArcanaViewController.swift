//
//  FavoritesArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class FavoritesArcanaViewController: ArcanaViewController {

    override var arcanaVC: ArcanaVC {
        get {
            return .favorites
        }
        set {}
    }
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editFavorites))
        return button
    }()
    
    lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(openSettings))
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadArcana()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("FavoritesArcanaView", screenClass: nil)
    }
    
    override func setupNavBar() {
        navigationItem.title = "즐겨찾기"
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = editButton

    }
    
    override func setupGestures() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }

    override func downloadArcana() {
            
        let uids = defaults.getFavorites()
        var array = [Arcana]()
        let group = DispatchGroup()
        
        for id in uids {
            group.enter()
            
            let ref = ARCANA_REF.child(id)
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let arcana = Arcana(snapshot: snapshot) {
                    array.append(arcana)
                }
                group.leave()
                
            })
        }
        
        group.notify(queue: .main) {
            self.initialLoad = false
            self.arcanaArray = array
            self.reloadView()
        }
        
    }
    
    func openSettings() {
        let vc = Settings()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func editFavorites() {
        
        if arcanaArray.count != 0 {
            
            tableViewSetEditing()
            
            if !tableView.isEditing {
                // set userDefaults to new array.
                var favoritesDict = [String: Int]()
                var uids = [String]()
                                
                for (index, arcana) in arcanaArray.enumerated() {
                    favoritesDict.updateValue(index, forKey: arcana.getUID())
                    uids.append(arcana.getUID())
                    
                }
                
                let userFavorites = defaults.getFavorites()
                
                if uids != userFavorites {
                    // made changes, upload to firebase
                    if let id = defaults.getUID() {
                        let ref = USERS_REF.child(id).child("favorites")
                        ref.setValue(favoritesDict)
                        defaults.setFavorites(value: uids)
                    }
                }
                
            }
            
        }
        else {
            if tableView.isEditing {
                tableViewSetEditing()
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

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.setEditing(editing, animated: animated)
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            // delete item at indexPath
            let idToRemove = self.arcanaArray[indexPath.section].uid
            self.concurrentArcanaQueue.async {
                self.arcanaArray.remove(at: indexPath.section)
            }
            
            var userFavorites = defaults.getFavorites()
            
            for (index, i) in userFavorites.enumerated() {

                if i == idToRemove {
                    userFavorites.remove(at: index)
                    if let userID = defaults.getUID() {
                        let ref = USERS_REF.child(userID).child("favorites").child(i)
                        ref.removeValue()
                        defaults.setFavorites(value: userFavorites)
                    }
                    
                    break
                }
                
            }
            
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = arcanaArray[sourceIndexPath.section]
        arcanaArray.remove(at: sourceIndexPath.section)
        arcanaArray.insert(itemToMove, at: destinationIndexPath.section)
        
    }

}

