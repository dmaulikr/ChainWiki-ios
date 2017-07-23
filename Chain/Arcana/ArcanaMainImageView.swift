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
//        view = loadViewFromNib()
//        
//        // use bounds not frame or it'll be offset
//        view.frame = bounds
//        
//        // Make the view stretch with containing view
//        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//        
//        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        addSubview(view)

        
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        let nibItems = nib.instantiate(withOwner: self, options: nil)
        if let nibView = nibItems.first as? UIView {
            //Add the view loaded from the nib into self.
            view = nibView
            if view != nil {
                view.frame = bounds
                addSubview(view)
            }
        }
        
    }
    
    func loadViewFromNib() -> UIView! {
        
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
