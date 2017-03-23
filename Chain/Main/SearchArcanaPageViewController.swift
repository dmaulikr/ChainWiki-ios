//
//  SearchArcanaPageViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/21/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SearchArcanaPageViewController: UIViewController {

    fileprivate var currentIndex: Int = 0

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        automaticallyAdjustsScrollViewInsets = false
    }
    
}
