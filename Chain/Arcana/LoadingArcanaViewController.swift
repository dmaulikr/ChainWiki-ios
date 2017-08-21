//
//  LoadingArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 4/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class LoadingArcanaViewController: UIViewController {

    let arcanaID: String
    let whiteView = UIView()
    let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
    
    init(arcanaID: String) {
        self.arcanaID = arcanaID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArcana()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(whiteView)
        view.addSubview(activityIndicator)
        
        whiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.anchorCenterSuperview()
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.layoutIfNeeded()
        activityIndicator.startAnimating()
    }

    func getArcana() {
        
        let arcanaRef = FIREBASE_REF.child("arcana").child(arcanaID)
        arcanaRef.observeSingleEvent(of: .value, with: { snapshot in
            
            print(snapshot)
            if let arcana = Arcana(snapshot: snapshot) {
                let vc = ArcanaDetail(arcana: arcana, site: true)
                vc.presentingDelegate = self
                self.present(NavigationController(vc), animated: true, completion: {
                    self.activityIndicator.stopAnimating()
                    self.whiteView.removeFromSuperview()
                })
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
            
            
        })
    }
}
