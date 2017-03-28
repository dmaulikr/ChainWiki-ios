//
//  ImageHelpers.swift
//  Chain
//
//  Created by Jitae Kim on 3/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Firebase

import UIKit
import Firebase

let imageCache = NSCache<NSString, UIImage>()

enum ImageType {
    case icon
    case main
}

extension UIImageView {
    
    func loadArcanaImage(_ arcanaID: String, imageType: ImageType, sender: AnyObject?) {

        var imageRef = ""
        
        switch imageType {
        case .icon:
            imageRef = arcanaID + "/icon.jpg"
        case .main:
            imageRef = arcanaID + "/main.jpg"
        }
        
        if defaults.getImagePermissions() {

            // check cache for image first
            if let cachedImage = imageCache.object(forKey: imageRef as NSString) {
                if let cell = sender as? ArcanaCell {
                    if cell.arcanaID == arcanaID {
                        self.image = cachedImage
                    }
                }
                else if let cell = sender as? ArcanaIconCell {
                    if cell.arcanaID == arcanaID {
                        self.image = cachedImage
                    }
                }
                else {
                    // sender is main arcana image
                    if let cell = sender as? ArcanaImageCell {
                        cell.activityIndicator.stopAnimating()
                        cell.imageLoaded = true
                        self.image = cachedImage
                    }
                    
                }
                return
            }
            
            // image not in cache, download from firebase
            STORAGE_REF.child("image/arcana").child(imageRef).downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    
                    // Handle any errors
                } else {
                    
                    URLSession.shared.dataTask(with: URL!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            return
                        }
                        
                        DispatchQueue.main.async(execute: {
                            
                            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                            
                            imageCache.setObject(downloadedImage, forKey: imageRef as NSString)
                            
                            if let cell = sender as? ArcanaCell {
                                // Only set the image if the cell is one that requested the download
                                if cell.arcanaID == arcanaID {
                                    
                                    cell.arcanaImage.image = downloadedImage
                                    self.alpha = 0
                                    self.fadeIn(withDuration: 0.2)

                                }
                            }
                            else if let cell = sender as? ArcanaIconCell {
                                if cell.arcanaID == arcanaID {
                                    
                                    cell.arcanaImage.image = downloadedImage
                                    self.alpha = 0
                                    self.fadeIn(withDuration: 0.2)
                                    
                                }

                            }
                            else {
                                if let cell = sender as? ArcanaImageCell {
                                    // Main image requested, just set the image.
                                    cell.imageLoaded = true
                                    cell.arcanaImage.image = downloadedImage
                                    self.alpha = 0
                                    self.fadeIn(withDuration: 0.2)
                                    cell.activityIndicator.stopAnimating()
                                }
                                
                            }
                            
                        })
                        
                    }).resume()
                    
                    
                }
            }

        }
    }
}


extension UIViewController {
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "저장 실패.", message: error.localizedDescription)
        } else {
            showAlert(title: "저장 완료!", message: "아르카나 정보가 사진에 저장되었습니다.")
        }
    }
    
    func generateImage(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frame.width, height: view.frame.height),false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        let previousFrame = view.frame
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        
        view.layer.render(in: context!)
        
        view.frame = previousFrame
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        UIGraphicsEndImageContext()
        
    }

}
