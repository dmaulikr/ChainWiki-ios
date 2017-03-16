//
//  ArcanaDetailEditCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaDetailEditCell: UITableViewCell {

    weak var editDelegate: ArcanaDetailEdit?
    
    let arcanaKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var arcanaAttributeTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        textView.spellCheckingType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.autocorrectionType = .no
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(arcanaKeyLabel)
        addSubview(arcanaAttributeTextView)
        
        arcanaKeyLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 80, heightConstant: 0)
        
        arcanaAttributeTextView.anchor(top: topAnchor, leading: arcanaKeyLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }

}

extension ArcanaDetailEditCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        editDelegate?.edited(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
