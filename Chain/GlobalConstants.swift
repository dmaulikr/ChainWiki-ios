//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

let FIREBASE_REF = FIRDatabase.database().reference()
let STORAGE_REF = FIRStorage.storage().reference()

let example = "https://xn--eckfza0gxcvmna6c.gamerch.com/年代記の剣士リヴェラ"
let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
let arcanaURL = "年代記の剣士リヴェラ"

let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")

let SCREENWIDTH = UIScreen.mainScreen().bounds.width
let SCREENHEIGHT = UIScreen.mainScreen().bounds.height

let DOWNLOADER = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .FIFO,
    maximumActiveDownloads: 4,
    imageCache: AutoPurgingImageCache()
)

let IMAGECACHE = AutoPurgingImageCache(
    memoryCapacity: 100 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
)

let WARRIORCOLOR = UIColor(red: 0.9882, green: 0.4039, blue: 0.4039, alpha: 1.0) /* #fc6767 */
let KNIGHTCOLOR = UIColor(red: 0.9882, green: 0.4039, blue: 0.4039, alpha: 1.0) /* #fc6767 */
let ARCHERCOLOR = UIColor(red: 0.9882, green: 0.4039, blue: 0.4039, alpha: 1.0) /* #fc6767 */
let MAGICIANCOLOR = UIColor(red: 0.9882, green: 0.4039, blue: 0.4039, alpha: 1.0) /* #fc6767 */
let HEALERCOLOR = UIColor(red: 0.9882, green: 0.4039, blue: 0.4039, alpha: 1.0) /* #fc6767 */
