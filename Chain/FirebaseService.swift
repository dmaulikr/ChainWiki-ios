//
//  FirebaseService.swift
//  Chain
//
//  Created by Jitae Kim on 10/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase
import AlamofireImage

class FirebaseService {
    
    static let dataRequest = FirebaseService()
    
    func authenticateUser() {
        
    }
    
    func downloadImage(uid: String, sender: UIImageView ) {
        
        STORAGE_REF.child("image/arcana/\(uid)/icon.jpg").downloadURL { (URL, error) -> Void in
            if (error != nil) {
                
                // Handle any errors
            } else {
                // Get the download URL
                let urlRequest = URLRequest(url: URL!)
                DOWNLOADER.download(urlRequest) { response in
                    
                    if let image = response.result.value {
                        // Set the Image
                        
                        if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {
                            
                            // Cache the Image
                            IMAGECACHE.add(thumbnail, withIdentifier: "\(uid)/icon.jpg")
                            //                                cell.imageSpinner.stopAnimating()
                            
//                            if sender.arcanaUID == arcana.uid {
                                sender.image = IMAGECACHE.image(withIdentifier: "\(uid)/icon.jpg")
                                sender.alpha = 0
                                sender.fadeIn(withDuration: 0.2)
//                            }
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
}
