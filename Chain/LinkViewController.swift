//
//  LinkViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView
import SafariServices

class LinkViewController: SFSafariViewController,SFSafariViewControllerDelegate {

    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
        return spinner
    }()
    
    init(url: URL) {
        super.init(url: url, entersReaderIfAvailable: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        delegate = self
        
    }
    
    func setupViews() {
        
        view.addSubview(activityIndicator)
        
        activityIndicator.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        activityIndicator.anchorCenterSuperview()
        activityIndicator.startAnimating()
        
    }


    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        activityIndicator.stopAnimating()
    }
}
