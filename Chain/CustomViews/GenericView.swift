//
//  GenericView.swift
//  Chain
//
//  Created by Jitae Kim on 7/23/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class GenericView: UIView {

    @IBOutlet weak var contentView: UIView!
    
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
            contentView = nibView
            addSubview(contentView)
            contentView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        }

    }
    
}
