//
//  FirebaseHandler.swift
//  Chain
//
//  Created by Jitae Kim on 9/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

/*
func downloadIcon(uid: String) -> UIImage? {
    
    // Check cache first
    if let image = IMAGECACHE.image(withIdentifier: "\(uid)/icon.jpg") {
        
        //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
        //            let crop = Toucan(image: i).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
        
        //            let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
        //            cell.arcanaImage.image = crop
        return image
    }
        
        //  Not in cache, download from firebase
    else {
        //            cell.imageSpinner.startAnimating()
        
        STORAGE_REF.child("image/arcana/\(uid)/icon.jpg").downloadURL { (URL, error) -> Void in
            if (error != nil) {
                print("image download error")
                // Handle any errors
            } else {
                // Get the download URL
                let urlRequest = URLRequest(url: URL!)
                
                DOWNLOADER.download(urlRequest) { response in
                    
                    if let image = response.result.value {

                        if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {

                            
                            print("DOWNLOADED")
                            
                            // Cache the Image
                            IMAGECACHE.add(thumbnail, withIdentifier: "\(uid)/icon.jpg")
                            
                            return thumbnail
                        }
                        
                        
                    }
                }
            }
        }
        
    }
    
}

*/
