//
//  FavoritesArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class FavoritesArcanaViewController: ArcanaViewController {

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
            
            let ref = FIREBASE_REF.child("arcana").child(id)
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let arcana = Arcana(snapshot: snapshot) {
                    array.append(arcana)
                }
                group.leave()
                
            })
        }
        
        group.notify(queue: .main) {
            
            self.arcanaArray = array
            self.reloadTableView()
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
                        let ref = FIREBASE_REF.child("user").child(id).child("favorites")
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        let arcana = arcanaArray[row]
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
        
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
            let idToRemove = self.arcanaArray[indexPath.row].uid
            self.arcanaArray.remove(at: indexPath.row)
            
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
            
        }
        
        return [delete]
    }

}

