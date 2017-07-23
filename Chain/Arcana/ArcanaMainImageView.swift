//
//  ArcanaMainImageView.swift
//  Chain
//
//  Created by Jitae Kim on 7/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaMainImageView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var arcanaImageView: UIImageView!
    var imageLoaded = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {

        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        let nibItems = nib.instantiate(withOwner: self, options: nil)
        if let nibView = nibItems.first as? UIView {
            view = nibView
            if view != nil {
                view.frame = bounds
                addSubview(view)
            }
        }
        
    }

}
