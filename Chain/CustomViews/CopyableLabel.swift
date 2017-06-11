//
//  CopyableLabel.swift
//  Chain
//
//  Created by Jitae Kim on 10/3/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class CopyableLabel: UILabel {


    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
    }
    
    override func layoutSubviews() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu(_:))))
    }
    
    @objc func showMenu(_ sender: AnyObject) {
        print("OI")
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return false
    }
    
}
