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
        self.customInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.customInit()
    }
    
    func customInit() {
        self.hidesNavigationBarDuringPresentation = false
        self.searchBar.searchBarStyle = .minimal
        self.dimsBackgroundDuringPresentation = false
        
        // KVO. potential future problems here.
        self.searchBar.setValue("취소", forKey:"_cancelButtonText")
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField, let searchIcon = searchTextField.leftView as? UIImageView {
            
            searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            searchIcon.tintColor = UIColor.white
            searchTextField.tintColor = UIColor.white
            let attributeColor = [NSForegroundColorAttributeName: UIColor.white]
            searchTextField.attributedPlaceholder = NSAttributedString(string: "이름 검색", attributes: attributeColor)
            searchTextField.textColor = UIColor.white
            if let clearButton = searchTextField.value(forKey: "clearButton") as? UIButton {
                clearButton.setImage(clearButton.imageView!.image!.withRenderingMode(.alwaysTemplate), for: .normal)
                clearButton.tintColor = UIColor.white
            }
            
        }

    }
    


}
