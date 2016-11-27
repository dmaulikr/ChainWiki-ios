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
import NVActivityIndicatorView

class CreateEmail: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var floatingTextFields: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordConfirm: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nickname: SkyFloatingLabelTextFieldWithIcon!
    var signedIn = false
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBAction func createEmail(_ sender: AnyObject) {

        self.view.endEditing(true)
        
        if let email = self.email.text, let password = self.password.text, let passwordConfirm = self.passwordConfirm.text, let nickname = self.nickname.text {
        
            if password == "" || passwordConfirm == "" {
                errorLabel.fadeOut(withDuration: 0.2)
                errorLabel.fadeIn(withDuration: 0.5)
                errorLabel.text = "비밀번호를 입력하세요."
            }
            
            else if nickname == "" || nickname.characters.count < 2 {
                errorLabel.fadeOut(withDuration: 0.2)
                errorLabel.fadeIn(withDuration: 0.5)
                errorLabel.text = "닉네임은 2자 이상이 필요합니다."
                spinner.stopAnimating()
            }
            else if password != passwordConfirm {
                errorLabel.fadeOut(withDuration: 0.2)
                errorLabel.fadeIn(withDuration: 0.5)
                errorLabel.text = "비밀번호가 맞지 않습니다."
                spinner.stopAnimating()
                }
                else {
                    spinner.startAnimating()
                    let nickNameRef = FIREBASE_REF.child("nickName/\(nickname)")
                    nickNameRef.observeSingleEvent(of: .value, with: { snapshot in
                        
                        if snapshot.exists() {
                            self.errorLabel.fadeOut(withDuration: 0.2)
                            self.errorLabel.fadeIn(withDuration: 0.5)
                            self.errorLabel.text = "닉네임이 이미 사용 중입니다."
                            self.spinner.stopAnimating()
                        }
                        else {
                            
                            if self.signedIn == true {
                                //link account to new email
//                                print("linking to email...")
                                
                                let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
                                
                                FIRAuth.auth()?.currentUser?.link(with: credential) { (user, error) in
                                    if error != nil {
                                        print("ERROR LINKING TO EMAIL")
                                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                            switch (errorCode) {
                                                
                                            case .errorCodeEmailAlreadyInUse:
                                                self.errorLabel.fadeOut(withDuration: 0.2)
                                                self.errorLabel.fadeIn(withDuration: 0.5)
                                                self.errorLabel.text = "이메일이 이미 사용 중입니다."
                                                
                                            case .errorCodeInvalidEmail:
                                                self.errorLabel.fadeOut(withDuration: 0.2)
                                                self.errorLabel.fadeIn(withDuration: 0.5)
                                                self.errorLabel.text = "이메일이 올바르지 않습니다."
                                                
                                            case .errorCodeWeakPassword:
                                                self.errorLabel.fadeOut(withDuration: 0.2)
                                                self.errorLabel.fadeIn(withDuration: 0.5)
                                                self.errorLabel.text = "비밀번호가 약합니다."
                                                
                                            default:
                                                print("some other error")
                                            }
                                            self.spinner.stopAnimating()
                                        }
                                        
                                    }
                                    else {
//                                        print("successfully linked email!")
                                        self.spinner.stopAnimating()
                                        guard let user = user else {
                                            return
                                        }
                                         
                                        let editPermissionsRef = FIREBASE_REF.child("user/\(user.uid)/edit")
                                        editPermissionsRef.setValue(true)
                                        let changeRequest = user.profileChangeRequest()
                                        changeRequest.displayName = nickname
                                        changeRequest.commitChanges { error in
                                            if let _ = error {
                                                print("could not set user's nickname")
                                            } else {
                                                print("user's nickname updated")
                                            }
                                        }
                                        
                                        
                                        defaults.setUID(value: user.uid)
                                        defaults.setEditPermissions(value: true)
                                        defaults.setName(value: nickname)
                                        
                                        nickNameRef.setValue(true)
                                        
                                        self.changeRootVC(vc: .login)
                                        
                                    }
                                }
                                
                            }
                            
                            else {
                                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                                    
                                    if error != nil {
                                        
                                        
                                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                            switch (errorCode) {
                                                
                                            case .errorCodeEmailAlreadyInUse:
                                                self.errorLabel.fadeOut(withDuration: 0.2)
                                                self.errorLabel.fadeIn(withDuration: 0.5)
                                                self.errorLabel.text = "이메일이 이미 사용 중입니다."
                                                
                                            case .errorCodeInvalidEmail:
                                                self.errorLabel.fadeOut(withDuration: 0.2)
                                                self.errorLabel.fadeIn(withDuration: 0.5)
                                                self.errorLabel.text = "이메일이 올바르지 않습니다."
                                                
                                            case .errorCodeWeakPassword:
                                                self.errorLabel.fadeOut(withDuration: 0.2)
                                                self.errorLabel.fadeIn(withDuration: 0.5)
                                                self.errorLabel.text = "비밀번호가 약합니다."
                                                
                                            default:
                                                print("some other error")
                                            }
                                            self.spinner.stopAnimating()
                                        }
                                    }
                                    else {
                                        
//                                        print("EMAIL ACCOUNT CREATED, LOGGING IN...")
                                        self.spinner.stopAnimating()
                                        guard let user = user else {
                                            return
                                        }
                                        
                                        
                                        let editPermissionsRef = FIREBASE_REF.child("user/\(user.uid)/edit")
                                        editPermissionsRef.setValue("true")
                                        let changeRequest = user.profileChangeRequest()
                                        changeRequest.displayName = nickname
                                        changeRequest.commitChanges { error in
                                            if let _ = error {
                                                print("could not set user's nickname")
                                            } else {
                                                print("user's nickname updated")
                                            }
                                        }
                                        
                                        defaults.setUID(value: user.uid)
                                        defaults.setEditPermissions(value: true)
                                        defaults.setName(value: nickname)
                                        
                                        nickNameRef.setValue(true)
                                        self.changeRootVC(vc: .login)
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    })
                    
                }
            }
   
    }
    
    func setupViews() {
        
        for textField in floatingTextFields {
            
            textField.clearButtonMode = .whileEditing
            textField.tintColor = Color.lightGreen
            textField.titleColor = Color.lightGreen
            textField.selectedIconColor = Color.lightGreen
            textField.selectedLineColor = Color.lightGreen
            textField.selectedTitleColor = Color.lightGreen
            textField.iconFont = UIFont(name: "FontAwesome", size: 15)
            textField.iconColor = Color.lightGray
            textField.errorColor = Color.darkSalmon
            textField.delegate = self
        }
        errorLabel.textColor = Color.darkSalmon
        email.iconText = "\u{f0e0}"
        email.keyboardType = .emailAddress
        email.tag = 0
        password.iconText = "\u{f023}"
        password.tag = 1
        passwordConfirm.iconText = "\u{f023}"
        passwordConfirm.tag = 2
        nickname.iconText = "\u{f007}"
        nickname.tag = 3
        password.isSecureTextEntry = true
        passwordConfirm.isSecureTextEntry = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            if textField == nickname {
                //do login stuff
                createEmail(self)
            }
        }
        // Do not add a line break
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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