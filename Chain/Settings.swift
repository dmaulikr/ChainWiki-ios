//
//  Settings.swift
//  Chain
//
//  Created by Jitae Kim on 10/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import NVActivityIndicatorView

class Settings: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var checkImage: UIImageView!
//    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBAction func logout(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "잠깐!", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.view.tintColor = salmonColor
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            // Remove the user's uid from storage.
            UserDefaults.standard.setValue(nil, forKey: "uid")
            
            try! FIRAuth.auth()!.signOut()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            UIView.transition(with: self.view.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                self.view.window!.rootViewController = initialViewController
                }, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = salmonColor
        }
        
    }
    
    @IBAction func changeNick(_ sender: AnyObject) {
        
        self.checkImage.fadeOut(withDuration: 0.2)
        
        if let nick = nickName.text {
            if nick.characters.count < 2 {
                print("DISPLAY > 2")
                self.checkImage.image = #imageLiteral(resourceName: "fail")
                self.checkImage.fadeIn()
            }
            else {
//                self.spinner.startAnimating()
                let checkNickRef = FIREBASE_REF.child("nickName/\(nick)")
                checkNickRef.observeSingleEvent(of: .value, with: { snapshot in
                    
                    if snapshot.exists() {
                        print("nick already exists")
                        self.checkImage.image = #imageLiteral(resourceName: "fail")
//                        self.spinner.stopAnimating()
                        self.checkImage.fadeIn()
                    }
                    else {
                        // set new nickname
                        let user = FIRAuth.auth()?.currentUser
                        if let user = user {
                            let changeRequest = user.profileChangeRequest()
                            
                            changeRequest.displayName = nick
                            changeRequest.commitChanges { error in
                                if let _ = error {
                                    // An error happened.
                                    print("update nick error")
                                    self.checkImage.image = #imageLiteral(resourceName: "fail")
                                    self.checkImage.fadeIn()
                                } else {
                                    // Profile updated.
                                    self.checkImage.image = #imageLiteral(resourceName: "check")
                                    
                                    
                                }
//                                self.spinner.stopAnimating()
                                self.checkImage.fadeIn()
                            }
                        }
                        
                        UserDefaults.standard.setValue(nick, forKey: "nickName")
                        
                        checkNickRef.setValue(true)
                    }
                })
            }
        }
        
        
        
    }
    @IBAction func sendEmail(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["jitaekim93@gmail.com"])
            mail.setSubject("체인크로니클 위키 iOS 앱 문의")
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.delegate = self
        // Do any additional setup after loading the view.
//        nickName.text
        
        if let userNick = UserDefaults.standard.string(forKey: "nickName") {
            print("user's nick from USERDEFAULTS is \(userNick)")
            nickName.text = userNick
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text {
            if text.characters.count < 2 {
                print("must be > 2")
                
            }
        }
        
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
