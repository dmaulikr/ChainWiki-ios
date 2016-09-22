//
//  UnderlinedLabel.swift
//  Chain
//
//  Created by Jitae Kim on 9/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class UnderlinedLabel: UILabel {
    
    override var text: String! {
        
        didSet {
            // swift < 2. : let textRange = NSMakeRange(0, count(text))
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            
            self.attributedText = attributedText
        }
    }
}
