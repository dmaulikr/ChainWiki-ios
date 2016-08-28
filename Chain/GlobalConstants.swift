//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

let example = "https://xn--eckfza0gxcvmna6c.gamerch.com/年代記の剣士リヴェラ"
let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
let arcanaURL = "年代記の剣士リヴェラ"

let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")