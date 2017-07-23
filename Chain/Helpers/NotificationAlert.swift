//
//  NotificationAlert.swift
//  Chain
//
//  Created by Jitae Kim on 6/30/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseMessaging

protocol NotificationAlert {
    func presentPrompt()
}

extension NotificationAlert where Self: UIViewController {
    
    func presentPrompt() {
        
//        let alert = UIAlertController(title: "푸시 알림", message: "새로운 아르카나가 추가되었을 때 알림을 받으시겠습니까?", preferredStyle: .alert)
        
        
    }
    
}

