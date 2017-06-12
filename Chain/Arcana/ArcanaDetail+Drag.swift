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
        let stringItemProvider = NSItemProvider(object: "Hello World" as NSString)
        return [
            UIDragItem(itemProvider: stringItemProvider)
        ]
    }
    
}



@available(iOS 11.0, *)
func customEnableDragging(on view: UIView, dragInteractionDelegate: UIDragInteractionDelegate) {
    let dragInteraction = UIDragInteraction(delegate: dragInteractionDelegate)
    view.addInteraction(dragInteraction)
}
