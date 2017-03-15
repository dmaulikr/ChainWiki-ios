
//
//  Favorites.swift
//  Chain
//
//  Created by Jitae Kim on 9/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Favorites: UIViewController {
    
    fileprivate var arcanaArray = [Arcana]()
    fileprivate var arcanaDataSource: ArcanaDataSource? {
        didSet {
            tableView.dataSource = arcanaDataSource
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.delegate = self
        tableView.estimatedRowHeight = 100

        tableView.alpha = 0

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
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
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
            
            self.arcanaArray = array
            self.arcanaDataSource = ArcanaDataSource(array)
            if array.count == 0 {
                self.tableView.alpha = 0
                self.tipLabel.fadeIn(withDuration: 0.5)
                
            }
            else {
                self.tipLabel.fadeOut(withDuration: 0.2)
                self.tableView.fadeIn(withDuration: 0.5)
            }
            self.tableView.reloadData()
        })

    }
    
    
}


extension Favorites: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let arcana = arcanaArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.setEditing(editing, animated: animated)
        tableView.endUpdates()
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = arcanaArray[sourceIndexPath.row]
        arcanaArray.remove(at: sourceIndexPath.row)
        arcanaArray.insert(itemToMove, at: destinationIndexPath.row)
        
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
            
            self.tableView.reloadData()
        }
        
        return [delete]
    }
    
}

extension Favorites: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        let arcana = arcanaArray[indexPath.row]
        
        let vc = ArcanaPeekPreview(arcana: arcana)
        vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)
        
        return vc
    }
    
}

