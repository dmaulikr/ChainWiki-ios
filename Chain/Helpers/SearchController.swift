//
//  SearchController.swift
//  Chain
//
//  Created by Jitae Kim on 10/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    
//    var searchController = UISearchController(searchResultsController: nil)
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        customInit()
    }
    
    func customInit() {
        hidesNavigationBarDuringPresentation = false
        searchBar.searchBarStyle = .minimal
        dimsBackgroundDuringPresentation = false
        
        // KVO. potential future problems here.
        searchBar.setValue("취소", forKey:"_cancelButtonText")
        searchBar.tintColor = Color.lightGreen
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField, let searchIcon = searchTextField.leftView as? UIImageView {
            
            searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            searchIcon.tintColor = Color.lightGreen
            searchTextField.tintColor = Color.lightGreen
            let attributeColor = [NSForegroundColorAttributeName: Color.lightGreen]
            searchTextField.attributedPlaceholder = NSAttributedString(string: "이름 검색", attributes: attributeColor)
            searchTextField.textColor = Color.lightGreen
            if let clearButton = searchTextField.value(forKey: "clearButton") as? UIButton {
                clearButton.setImage(clearButton.imageView!.image!.withRenderingMode(.alwaysTemplate), for: .normal)
                clearButton.tintColor = .lightGray
            }
            
        }

    }
    


}
