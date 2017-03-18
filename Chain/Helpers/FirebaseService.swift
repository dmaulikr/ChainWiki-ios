//
//  FirebaseService.swift
//  Chain
//
//  Created by Jitae Kim on 10/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    
    static let dataRequest = FirebaseService()
    
    private var FIREBASE_REF = FIRDatabase.database().reference()
    private var ARCANA_REF = FIRDatabase.database().reference().child("arcana")

    private var STORAGE_REF = FIRStorage.storage().reference()
    
    func incrementCount(ref: FIRDatabaseReference) {
        
        ref.runTransactionBlock({ data -> FIRTransactionResult in
            
            if let chatCount = data.value as? Int {
                data.value = chatCount + 1
            }
            return FIRTransactionResult.success(withValue: data)
            
        })
        
    }
    
    func incrementLikes(uid: String, increment: Bool) {
        let ref = ARCANA_REF.child("\(uid)/numberOfLikes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let base = snapshot.value as? Int else {
                return
            }
            
            if increment {
                ref.setValue(base+1)
            }
            else if base > 0 {
                   ref.setValue(base-1)
            }
            
            
            
        })
    }
    
    
}
