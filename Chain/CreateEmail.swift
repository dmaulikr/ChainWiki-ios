//
//  CreateEmail.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import Firebase

class CreateEmail: UIViewController, UITextFieldDelegate {

    @IBOutlet var floatingTextFields: [SkyFloatingLabelTextFieldWithIcon]!
    
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordConfirm: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nickname: SkyFloatingLabelTextFieldWithIcon!
    
    @IBAction func createEmail(_ sender: AnyObject) {

        
        if let email = self.email.text, let password = self.password.text, let passwordConfirm = self.passwordConfirm.text {
            
            if password != passwordConfirm {
                print("passwords do not match")
            }
            else {
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    
                    
                    if error != nil {
                        
                        
                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                            switch (errorCode) {
                                
                            case .errorCodeEmailAlreadyInUse:
                                print("Email already in use")
                                
                            case .errorCodeInvalidEmail:
                                print("invalid email")
                                
                            case .errorCodeWeakPassword:
                                print("weak password")
                                
                            default:
                                print("Some other error")
                            }
                        }
                    }
                    else {
                        print("EMAIL ACCOUNT CREATED, LOGGING IN...")
                        let uid = user!.uid
                        UserDefaults.standard.setValue(uid, forKey: "uid")
                        
                        self.changeRootView()
                    }
                }
            }
            
            
        }
        
        
    }
    
    func setupViews() {
        
        for textField in floatingTextFields {
            
            textField.clearButtonMode = .whileEditing
            textField.tintColor = lightGreenColor
            textField.selectedIconColor = lightGreenColor
            textField.selectedLineColor = lightGreenColor
            textField.selectedTitleColor = lightGreenColor
            textField.iconFont = UIFont(name: "FontAwesome", size: 15)
            textField.iconColor = lightGrayColor
            textField.errorColor = darkSalmonColor
            textField.delegate = self
        }
        
        email.iconText = "\u{f0e0}"
        password.iconText = "\u{f023}"
        passwordConfirm.iconText = "\u{f023}"
        nickname.iconText = "\u{f007}"
        password.isSecureTextEntry = true
        passwordConfirm.isSecureTextEntry = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if let text = textField.text {
            
            switch textField {
                
            case email:
                if let floatingLabelTextField = email {
                    if(!text.isEmail) {
                        floatingLabelTextField.errorMessage = "올바른 이메일을 입력하세요."
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
           
            case password:
                if let floatingLabelTextField = password {
                    if(text.characters.count < 6) {
                        floatingLabelTextField.errorMessage = "6자 이상 입력하세요."
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
                
            case passwordConfirm:
                if let floatingLabelTextField = passwordConfirm {
                    if(text != password.text) {
                        floatingLabelTextField.errorMessage = "비밀번호가 맞지 않습니다."
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
                
            default:
                
                if let floatingLabelTextField = nickname {
                    let ref = FIREBASE_REF.child("nickname/\(text)")
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        
                        if snapshot.exists() {
                            floatingLabelTextField.errorMessage = "닉네임이 이미 존재합니다."
                        }
                            
                        else {
                            floatingLabelTextField.errorMessage = ""
                        }
                        
                    })
                }
            }

        }
    }

    
    func changeRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController")
        
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
