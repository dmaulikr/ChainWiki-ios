//
//  TavernArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class TavernArcanaViewController: ArcanaViewController {
    
    override var arcanaDataSource: ArcanaDataSource? {
        didSet {
            tableView.dataSource = arcanaDataSource
            if arcanaDataSource!.arcanaArray.count > 0 {
                tableView.alpha = 1
                tipLabel.alpha = 0
            }
            else {
                tableView.alpha = 0
                tipLabel.alpha = 1
            }
            tableView.reloadData()
        }
    }
    
    init(tavernKR: String, tavernEN: String) {
        super.init()
        ref = FIREBASE_REF.child("tavern").child(tavernEN)
        navigationItem.title = tavernKR
        tableView.alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func downloadArcana() {
        
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

                self.originalArray = array
                let raritySortedArray = array.sorted { $0.getRarity() > $1.getRarity() }
                self.arcanaDataSource = ArcanaDataSource(raritySortedArray)
            })
            
        })

    }
}
