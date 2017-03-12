//
//  ImageHelpers.swift
//  Chain
//
//  Created by Jitae Kim on 3/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

func generateImage(view: UIView) {
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frame.width, height: view.frame.height),false, 0.0)
    
    let context = UIGraphicsGetCurrentContext()
    
    let previousFrame = view.frame
    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
    
    
    view.layer.render(in: context!)
    
    view.frame = previousFrame
    
    if let image = UIGraphicsGetImageFromCurrentImageContext() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    UIGraphicsEndImageContext()
    
    
    
    
}
