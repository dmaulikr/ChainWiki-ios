//
//  PushNotificationViewController.swift
//  Chain
//
//  Created by Jitae Kim on 6/30/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseMessaging
import FirebaseAnalytics

class PushNotificationViewController: UIViewController {

    @IBOutlet weak var addOnlyButton: UIButton!
    @IBOutlet weak var editOnlyButton: UIButton!
    @IBOutlet weak var receiveAllButton: UIButton!
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(declinePush(_:)))
        return button
    }()
    
    @IBAction func acceptPush(_ sender: UIButton) {
        
        switch sender {
        case addOnlyButton:
            Messaging.messaging().subscribe(toTopic: "addArcana")
            Analytics.logEvent("Push Notifications", parameters: [
                "type" : "Add" as NSObject
                ])
        case editOnlyButton:
            Messaging.messaging().subscribe(toTopic: "updateArcana")
            Analytics.logEvent("Push Notifications", parameters: [
                "type" : "Update" as NSObject
                ])
        case receiveAllButton:
            Messaging.messaging().subscribe(toTopic: "addArcana")
            Messaging.messaging().subscribe(toTopic: "updateArcana")
            Analytics.logEvent("Push Notifications", parameters: [
                "type" : "Add & Update" as NSObject
                ])
        default:
            break
        }
        
        dismiss(animated: true) { 
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.requestNotifications()
        }
        
    }
    
    @IBAction func declinePush(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        Analytics.logEvent("Push Notifications", parameters: [
            "type" : "Declined" as NSObject
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.title = "푸시 알림"
        navigationItem.leftBarButtonItem = cancelButton
    }
    
}
