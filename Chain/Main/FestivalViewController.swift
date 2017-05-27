//
//  FestivalViewController.swift
//  Chain
//
//  Created by Jitae Kim on 5/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class FestivalViewController: ArcanaViewController {

    override func setupNavBar() {
        super.setupNavBar()
        
        navigationItem.title = "FESTIVAL"
        
//        let dismissButton = UIBarButtonItem(title: "홈", style: .plain, target: self, action: #selector(dismissView))
//        navigationItem.leftBarButtonItem = dismissButton
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    override func downloadArcana() {
        
        ref = FIREBASE_REF.child("festival")
        
        ref.queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            let group = DispatchGroup()
            
            for id in uid {
                group.enter()
                
                let ref = ARCANA_REF.child(id)
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        self.arcanaArray.append(arcana)
                        self.originalArray.append(arcana)
//                        self.arcanaDictionary[arcana.getUID()] = arcana
//                        self.arcanaOriginalDictionary[arcana.getUID()] = arcana
                    }
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                
                self.initialLoad = false
//                self.originalArray = Array(self.arcanaOriginalDictionary.values)
//                self.arcanaArray = Array(self.arcanaDictionary.values)
                self.reloadView()
            })

        })
    }


}
