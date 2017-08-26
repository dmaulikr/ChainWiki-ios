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

enum ImageType: String {
    case profile
    case main
}

class ImageHelper {
    
    static let shared = ImageHelper()
    
    func prefetchImages(arcanaID: String, urlString: String?) {
        
        if defaults.getImagePermissions() {
            
            if let urlString = urlString, let url = URL(string: urlString) {
                
                // check cache for image first
                if let _ = imageCache.object(forKey: urlString as NSString) {
                    return
                }
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        
                        
                    }
                    
                    guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                }).resume()
            }
        }
    }
}

extension UIImageView {
    
    func animateImage(_ image: UIImage) {
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
        
    }
    
    func loadArcanaImage(arcanaID: String, urlString: String?, completion: @escaping (String, UIImage) -> ()) {
        
//        completion(arcanaID, #imageLiteral(resourceName: "sampleMainImage"))
//        return
        self.image = nil
        
        if defaults.getImagePermissions() {
            
            if let urlString = urlString, let url = URL(string: urlString) {
                
                // check cache for image first
                if let cachedImage = imageCache.object(forKey: urlString as NSString) {
                    completion(arcanaID, cachedImage)
                    return
                }
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        
                        if let cachedPlaceholder = imageCache.object(forKey: "placeHolder") {
                            completion(arcanaID, cachedPlaceholder)
                        }
                        else {
                            DispatchQueue.main.async {
                                completion(arcanaID, #imageLiteral(resourceName: "AppLogo"))
//                                UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
//                                if let placeholder = ChainLogo.drawPlaceholder(size: self.frame.size) {
//                                    imageCache.setObject(placeholder, forKey: "placeholder" as NSString)
//                                    completion(arcanaID, placeholder)
//                                }
//
                            }
                        }
                        
                    }
                    
                    guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                    
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    completion(arcanaID, downloadedImage)
                    
                }).resume()
            }
            else {
                
                if let cachedPlaceholder = imageCache.object(forKey: "placeHolder") {
                    completion(arcanaID, cachedPlaceholder)
                }
                else {
                    DispatchQueue.main.async {
                        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
                        let placeholder = ChainLogo.drawPlaceholder(size: self.frame.size)
                        imageCache.setObject(placeholder, forKey: "placeholder" as NSString)
                        completion(arcanaID, placeholder)
                    }
                }
            }
        }
    }
    
    func loadArcanaImage(_ arcanaID: String, imageType: ImageType, completion: @escaping (UIImage) -> ()) {

        let imageRef: String
        
        switch imageType {
        case .profile:
            imageRef = arcanaID + "/icon.jpg"
        case .main:
            imageRef = arcanaID + "/main.jpg"
        }
        
        if defaults.getImagePermissions() {

            // check cache for image first
            if let cachedImage = imageCache.object(forKey: imageRef as NSString) {
                completion(cachedImage)
            }
            
            else {
                
                DispatchQueue.main.async {
                    self.image = nil
                }

                STORAGE_REF.child("image/arcana").child(imageRef).downloadURL { (URL, error) -> Void in
                    
                    if (error != nil) {
                        
                        DispatchQueue.main.async {
                            completion(#imageLiteral(resourceName: "AppLogo"))
//                            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
//                            let placeholder = ChainLogo.drawPlaceholder(size: self.frame.size)
//                            imageCache.setObject(placeholder, forKey: imageRef as NSString)
//                            completion(placeholder)
                        }
                        
                    } else {
                        
                        URLSession.shared.dataTask(with: URL!, completionHandler: { (data, response, error) in
                            
                            if error != nil {
                                
                                DispatchQueue.main.async {
                                    completion(#imageLiteral(resourceName: "AppLogo"))
//                                    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
//                                    let placeholder = ChainLogo.drawPlaceholder(size: self.frame.size)
//                                    imageCache.setObject(placeholder, forKey: imageRef as NSString)
//                                    completion(placeholder)
                                }
                                
                            }
                            
                            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                            
                            imageCache.setObject(downloadedImage, forKey: imageRef as NSString)
                            completion(downloadedImage)
                            
                        }).resume()
                        
                    }
                    
                }

            }
            
        }

    }
    
}


extension UIViewController {
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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

