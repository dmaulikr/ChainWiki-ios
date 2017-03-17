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

    let DOWNLOADER = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    let IMAGECACHE = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
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
    func downloadImage(uid: String, sender: AnyObject) {
        
        if defaults.getImagePermissions() {
            if let sender = sender as? ArcanaCell {
                
                STORAGE_REF.child("image/arcana/\(uid)/icon.jpg").downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                        
                        // Handle any errors
                    } else {
                        let urlRequest = URLRequest(url: URL!)
                        self.DOWNLOADER.download(urlRequest) { response in
                            
                            if let image = response.result.value {
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0.5)!) {
                                    
                                    self.IMAGECACHE.add(thumbnail, withIdentifier: "\(uid)/icon.jpg")
                                    
                                    if sender.arcanaUID == uid {
                                        sender.arcanaImage.image = self.IMAGECACHE.image(withIdentifier: "\(uid)/icon.jpg")
//                                        if animated {
                                            sender.arcanaImage.alpha = 0
                                            sender.arcanaImage.fadeIn(withDuration: 0.2)
//                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                
            }
                
            else if let sender = sender as? ArcanaImageCell {
                STORAGE_REF.child("image/arcana/\(uid)/main.jpg").downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                        // Handle any errors
                    } else {
                        
                        let urlRequest = URLRequest(url: URL!)
                        self.DOWNLOADER.download(urlRequest) { response in
                            
                            if let image = response.result.value {
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0.7)!) {
                                    
                                    sender.activityIndicator.stopAnimating()
                                    let size = CGSize(width: SCREENWIDTH, height: 400)
                                    let aspectScaledToFitImage = thumbnail.af_imageAspectScaled(toFit: size)
                                    
                                    sender.arcanaImage.image = aspectScaledToFitImage
                                    sender.arcanaImage.alpha = 0
                                    sender.arcanaImage.fadeIn(withDuration: 0.2)
                                    
                                    self.IMAGECACHE.add(thumbnail, withIdentifier: "\(uid)/main.jpg")
                                }
                                
                            }
                        }
                    }
                }
                
            }

        }
        else if let sender = sender as? ArcanaImageCell {
            sender.activityIndicator.stopAnimating()
        }
        
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
