//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

let FIREBASE_REF = FIRDatabase.database().reference()
let STORAGE_REF = FIRStorage.storage().reference()

let example = "https://xn--eckfza0gxcvmna6c.gamerch.com/年代記の剣士リヴェラ"
let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
let arcanaURL = "年代記の剣士リヴェラ"

let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")

let SCREENWIDTH = UIScreen.mainScreen().bounds.width
let SCREENHEIGHT = UIScreen.mainScreen().bounds.height
