//
//  SearchBar.swift
//  Chain
//
//  Created by Jitae Kim on 3/27/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        searchBarStyle = .prominent
        setValue("취소", forKey:"_cancelButtonText")
        tintColor = Color.lightGreen
        barTintColor = .white
        backgroundColor = .white

        if let searchTextField = value(forKey: "searchField") as? UITextField, let searchIcon = searchTextField.leftView as? UIImageView {
            
            searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            searchIcon.tintColor = Color.lightGreen
            searchTextField.tintColor = Color.lightGreen
            let attributeColor = [NSForegroundColorAttributeName: Color.lightGreen]
            searchTextField.attributedPlaceholder = NSAttributedString(string: "이름 검색", attributes: attributeColor)
            searchTextField.textColor = .black
            if let clearButton = searchTextField.value(forKey: "clearButton") as? UIButton {
                clearButton.setImage(clearButton.imageView!.image!.withRenderingMode(.alwaysTemplate), for: .normal)
                clearButton.tintColor = .lightGray
            }
            
        }

    }

}
