//
//  UpdateObserving.swift
//  Chain
//
//  Created by Jitae Kim on 8/24/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Firebase

protocol UpdateObserving {
    
    func removeObservers()
    
}

class FirebaseObserver: UpdateObserving {
    
    private var handle: UInt
    private var firebaseReference: DatabaseReference
    
    init(handle: UInt, firebaseRef: DatabaseReference) {
        self.handle = handle
        self.firebaseReference = firebaseRef
    }
    
    func removeObservers() {
        firebaseReference.removeObserver(withHandle: handle)
    }
}
