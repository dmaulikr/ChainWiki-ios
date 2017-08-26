//
//  FirebaseApi.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Firebase

class FirebaseApi: NSObject {

    static let shared = FirebaseApi()
    
    // This will give back an array of Arcana IDs, which will then be used to fetch the full data at /arcana
    func arcanaIDsAt(_ ref: DatabaseReference, completion: @escaping ([String], Error?) -> ()) {

        var arcanaIDArray = [String]()

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            arcanaIDArray = self.arcanaIDsForSnapshot(snapshot)
            completion(arcanaIDArray, nil)
            
        }) { (error) in
            
            completion(arcanaIDArray, error)
            
        }
        
    }
    
    // Currently only used for festival. Order by snapshot value.
    func arcanaIDsOrderedByValue(_ ref: DatabaseReference, completion: @escaping ([String], Error?) -> ()) {
        
        var arcanaIDArray = [String]()
        
        ref.queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapshot) in
            
            arcanaIDArray = self.arcanaIDsForSnapshot(snapshot)
            completion(arcanaIDArray, nil)
            
        }) { (error) in
            
            completion(arcanaIDArray, error)
            
        }
    }
    
    func arcanaIDsForSnapshot(_ snapshot: DataSnapshot) -> [String] {
        
        var arcanaIDArray = [String]()
        
        for child in snapshot.children {
            let arcanaID = (child as AnyObject).key as String
            arcanaIDArray.append(arcanaID)
        }
        
        return arcanaIDArray
    }
    
}
