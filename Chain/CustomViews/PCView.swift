//
//  PCView.swift
//  Chain
//
//  Created by Jitae Kim on 12/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class PCView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        ChainLogo.drawLogo()
    }
 

}
