//
//  ArcanaEditModel.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

struct ArcanaEditModel {
    
    var arcana: ArcanaEdit!
    var editorID: String!
    var editorName: String!
    var arcanaRef: DatabaseReference!
    var date: String!
    
    init(a: ArcanaEdit, id: String, name: String, ref: DatabaseReference!, d: String) {
        
        arcana = a
        editorID = id
        editorName = name
        arcanaRef = ref
        date = d
    }
    
    
}
