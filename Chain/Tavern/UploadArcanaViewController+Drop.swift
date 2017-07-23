//
//  UploadArcanaViewController+Drop.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 6/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension UploadArcanaViewController: UIDropInteractionDelegate {
    
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
            
            if interaction.view == self.arcanaProfileImageView {
                self.arcanaProfileImageView.image = image
            }
            else {
                self.arcanaMainImageView.image = image
            }
        }
    }
}


