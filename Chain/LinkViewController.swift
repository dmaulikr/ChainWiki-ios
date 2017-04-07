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

class LinkViewController: SFSafariViewController, SFSafariViewControllerDelegate {

    let url: URL
    
    lazy var browserButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "브라우저", style: .plain, target: self, action: #selector(openBrowser))
        return button
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
        return spinner
    }()
    
    init(url: URL) {
        self.url = url
        super.init(url: url, entersReaderIfAvailable: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        delegate = self
        
    }
    
    func setupViews() {
        
        view.addSubview(activityIndicator)
        
        activityIndicator.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        activityIndicator.anchorCenterSuperview()
        activityIndicator.startAnimating()
        
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = browserButton
    }

    func openBrowser() {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = Color.salmon
        alertController.setValue(NSAttributedString(string:
            "브라우저 선택", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 20),NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")
        
        let chrome = UIAlertAction(title: "크롬으로 열기", style: .default, handler: { action in
            self.openChrome()
        })
        alertController.addAction(chrome)
        
        let safari = UIAlertAction(title: "사파리로 열기", style: .default, handler: { action in
            self.openSafari()
        })
        alertController.addAction(safari)

        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        if let presenter = alertController.popoverPresentationController {
            presenter.barButtonItem = browserButton
        }
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })

    }
    
    func openChrome() {
        let urlString = url.absoluteString.replacingOccurrences(of: "https://", with: "")
        let chromeURLString = "googlechrome://" + urlString
        guard let chromeURL = URL(string: chromeURLString) else { return }
        UIApplication.shared.openURL(chromeURL)
    }
    
    func openSafari() {
        guard let url = URL(string: url.absoluteString) else { return }
        UIApplication.shared.openURL(url)
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        activityIndicator.stopAnimating()
    }
}
