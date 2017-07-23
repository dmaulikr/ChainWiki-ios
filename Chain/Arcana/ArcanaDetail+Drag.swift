//
//  ArcanaDetail+Drag.swift
//  Chain
//
//  Created by Jitae Kim on 6/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension ArcanaDetail: UIDragInteractionDelegate {
    
    @available(iOS 11.0, *)
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        if let image = screenShot() {
            let provider = NSItemProvider(object: image)
            return [
                UIDragItem(itemProvider: provider)
            ]
        }
        
        return []
        
    }
    
}

@available(iOS 11.0, *)
func customEnableDragging(on view: UIView, dragInteractionDelegate: UIDragInteractionDelegate) {
    let dragInteraction = UIDragInteraction(delegate: dragInteractionDelegate)
    view.addInteraction(dragInteraction)
}

