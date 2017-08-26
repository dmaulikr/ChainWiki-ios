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

    var observedRefs = [DatabaseReference]()
    
    override func setupNavBar() {
        super.setupNavBar()
        navigationItem.title = "FESTIVAL"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("FestivalArcanaView", screenClass: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for ref in observedRefs {
            ref.removeAllObservers()
        }
    }
    
    override func downloadArcana() {
        
        FirebaseApi.shared.arcanaIDsOrderedByValue(FESTIVAL_REF) { (data, error) in
            
            let uid = data

            let group = DispatchGroup()
            
            for id in uid {
                group.enter()
                
                let ref = ARCANA_REF.child(id)
                self.observedRefs.append(ref)
                ref.observe(.value, with: { (snapshot) in

                    if let arcana = Arcana(snapshot: snapshot) {
                        
                        self.concurrentArcanaQueue.async(flags: .barrier) {
                            self._arcanaArray.append(arcana)
                        }
                    }
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.reloadView()
            })
            
        }
    }
        

}
