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

    private var FIREBASE_REF = FIRDatabase.database().reference()
    private var ARCANA_REF = FIRDatabase.database().reference().child("arcana")

    private var STORAGE_REF = FIRStorage.storage().reference()
    
    func downloadImage(uid: String, sender: AnyObject) {
        
        if defaults.getImagePermissions() {
            if let sender = sender as? ArcanaCell {
                
                STORAGE_REF.child("image/arcana/\(uid)/icon.jpg").downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                        
                        // Handle any errors
                    } else {
                        let urlRequest = URLRequest(url: URL!)
                        DOWNLOADER.download(urlRequest) { response in
                            
                            if let image = response.result.value {
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0.5)!) {
                                    
                                    IMAGECACHE.add(thumbnail, withIdentifier: "\(uid)/icon.jpg")
                                    
                                    if sender.arcanaUID == uid {
                                        sender.arcanaImage.image = IMAGECACHE.image(withIdentifier: "\(uid)/icon.jpg")
//                                        sender.arcanaImage.alpha = 0
//                                        sender.arcanaImage.fadeIn(withDuration: 0.2)
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
                        DOWNLOADER.download(urlRequest) { response in
                            
                            if let image = response.result.value {
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0.7)!) {
                                    
                                    sender.imageSpinner.stopAnimating()
                                    let size = CGSize(width: SCREENWIDTH, height: 400)
                                    let aspectScaledToFitImage = thumbnail.af_imageAspectScaled(toFit: size)
                                    
                                    sender.arcanaImage.image = aspectScaledToFitImage
                                    sender.arcanaImage.alpha = 0
                                    sender.arcanaImage.fadeIn(withDuration: 0.2)
                                    
                                    IMAGECACHE.add(thumbnail, withIdentifier: "\(uid)/main.jpg")
                                }
                                
                            }
                        }
                    }
                }
                
            }

        }
        else if let sender = sender as? ArcanaImageCell {
            sender.imageSpinner.stopAnimating()
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
