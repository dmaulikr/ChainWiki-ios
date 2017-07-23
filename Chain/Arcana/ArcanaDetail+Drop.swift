//
//  ArcanaDetail+Drop.swift
//  Chain
//
//  Created by Jitae Kim on 6/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension ArcanaDetail: UIDropInteractionDelegate {
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            
            guard let images = imageItems as? [UIImage], let image = images.first else { return }
            
            let imageView: UIImageView
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ArcanaImageCell {
                imageView = cell.arcanaImageView
            }
            else {
                imageView = self.arcanaImageView
            }
            
            self.animateUpload()
            
            let dataRequest = FirebaseService.dataRequest
            dataRequest.uploadArcanaImage(arcanaID: self.arcana.getUID(), image: image, imageType: .main, completion: { success in
                
                self.animateLabel(success: success)
                if !success {
                    imageView.loadArcanaImage(self.arcana.getUID(), imageType: .main, completion: { arcanaImage in
                        
                        DispatchQueue.main.async {
                            imageView.animateImage(arcanaImage)
                        }
                    })
                }
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.animatedView.fadeOut()
//                }, completion: { finished in
////                    self.activityIndicator.removeFromSuperview()
//                    self.activityIndicator.stopAnimating()
//                    self.animatedView.removeFromSuperview()
//                    
//                    
//                })
                
            })
            
        }
    }
}

@available(iOS 11.0, *)
func customEnableDropping(on view: UIView, dropInteractionDelegate: UIDropInteractionDelegate) {
    let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
    view.addInteraction(dropInteraction)
}
