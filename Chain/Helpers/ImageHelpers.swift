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
    
    func loadImageUsingCacheWithUrlString(_ arcanaIDWithImageType: String) {

        if defaults.getImagePermissions() {
        
            self.image = nil
            contentMode = .scaleAspectFit
            
            //check cache for image first
            if let cachedImage = imageCache.object(forKey: arcanaIDWithImageType as NSString) {
                self.image = cachedImage
                return
            }
            
            // image not in cache, download from firebase
            STORAGE_REF.child("image/arcana").child(arcanaIDWithImageType).downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    
                    // Handle any errors
                } else {
                    print("URL IS \(URL)")
                    
                    URLSession.shared.dataTask(with: URL!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        DispatchQueue.main.async(execute: {
                            
                            if let downloadedImage = UIImage(data: data!) {
                                imageCache.setObject(downloadedImage, forKey: arcanaIDWithImageType as NSString)
                                self.alpha = 0
                                self.fadeIn(withDuration: 0.2)
                                self.image = downloadedImage
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
