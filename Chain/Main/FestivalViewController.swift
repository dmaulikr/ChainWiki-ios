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
    }
    
    override func downloadArcana() {
        
        ref = FIREBASE_REF.child("festival")
        
        ref.queryOrderedByValue().observe(.childAdded, with: { snapshot in
            
            let arcanaRef = ARCANA_REF.child(snapshot.key)
            
            arcanaRef.observe(.value, with: { snapshot in
                
                DispatchQueue.global().async {
                    
                    if let arcana = Arcana(snapshot: snapshot) {
                        
                        if let index = self.arcanaArray.index(where: {$0.getUID() == snapshot.key}) {
                            
                            if !snapshot.exists() {
                                // arcana was removed
                                self.concurrentArcanaQueue.async(flags: .barrier) {
                                    self._arcanaArray.remove(at: index)
                                    DispatchQueue.main.async {
                                        self.deleteIndexPathAt(index: index)
                                    }
                                }
                                
                                if let index = self.originalArray.index(where: {$0.getUID() == snapshot.key}) {
                                    self.concurrentArcanaOriginalQueue.async(flags: .barrier) {
                                        self._originalArray.remove(at: index)
                                    }
                                }
                            }
                            else {
                                // arcana was updated
                                self.concurrentArcanaQueue.async(flags: .barrier) {
                                    self._arcanaArray[index] = arcana
                                    DispatchQueue.main.async {
                                        self.reloadIndexPathAt(index)
                                    }

                                }
                                
                                if let index = self.originalArray.index(where: {$0.getUID() == snapshot.key}) {
                                    self.concurrentArcanaOriginalQueue.async(flags: .barrier) {
                                        self.originalArray[index] = arcana
                                    }
                                }

                            }
                        }
                        else {
                            // add the arcana
                            self.concurrentArcanaQueue.async(flags: .barrier) {
                                self._arcanaArray.append(arcana)
                                DispatchQueue.main.sync {
                                    self.initialLoad = false
                                    self.reloadView()
                                }

                            }
                            
                            self.concurrentArcanaOriginalQueue.async(flags: .barrier) {
                                self.originalArray.append(arcana)
                            }
                        }

                    }
                    
                }

            })
            
        })
        
        ref.queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            DispatchQueue.main.async {
                self.reloadView()
            }
        })
        
//        ref.queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in
//            
//            var uid = [String]()
//            
//            for child in snapshot.children {
//                let arcanaID = (child as AnyObject).key as String
//                uid.append(arcanaID)
//            }
//            
//            let group = DispatchGroup()
//            
//            for id in uid {
//                group.enter()
//                
//                let ref = ARCANA_REF.child(id)
//                
//                ref.observeSingleEvent(of: .value, with: { snapshot in
//                    if let arcana = Arcana(snapshot: snapshot) {
//                        self.arcanaArray.append(arcana)
//                        self.originalArray.append(arcana)
//                    }
//                    group.leave()
//                })
//            }
//            
//            group.notify(queue: DispatchQueue.main, execute: {
//                
//                self.initialLoad = false
//                self.reloadView()
//            })
//
//        })
    }


}
