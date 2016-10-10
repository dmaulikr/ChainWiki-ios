//
//  User.swift
//  Chain
//
//  Created by Jitae Kim on 10/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var favorites: String?
    
    init?(snapshot: FIRDataSnapshot) {
        
        if let f = (snapshot.value as? NSDictionary)?["favorites"] as? String {
            favorites = f
        }
        
    }
    
    
}
