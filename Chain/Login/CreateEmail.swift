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

class CreateEmail: UIViewController, DisplayBanner {

    @IBOutlet weak var popupView: UIScrollView!

    @IBOutlet var floatingTextFields: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordConfirm: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nickname: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    
    var signedIn = false
    var keyboardShown = false
    
    @IBAction func closePopup(_ sender: Any) {
        
        animateRemovePopup()
        
        
    }
    @IBAction func createEmail(_ sender: AnyObject) {

        self.view.endEditing(true)
        var errorText = ""
        
        if let email = self.email.text, let password = self.password.text, let passwordConfirm = self.passwordConfirm.text, let nickname = self.nickname.text {
        
            if password == "" || passwordConfirm == "" {
                errorText = "비밀번호를 입력하세요."
                self.displayBanner(desc: errorText)
            }
            
            else if nickname == "" || nickname.characters.count < 2 {
                errorText = "닉네임은 2자 이상이 필요합니다."
                spinner.stopAnimating()
                self.displayBanner(desc: errorText)
            }
            else if password != passwordConfirm {

                errorText = "비밀번호가 맞지 않습니다."
                spinner.stopAnimating()
                self.displayBanner(desc: errorText)
            }
            else {
                    spinner.startAnimating()
                    let nickNameRef = FIREBASE_REF.child("nickName/\(nickname)")
                    nickNameRef.observeSingleEvent(of: .value, with: { snapshot in
                        
                        if snapshot.exists() {

                            errorText = "닉네임이 이미 사용 중입니다."
                            self.displayBanner(desc: errorText)
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
                                                errorText = "이메일이 이미 사용 중입니다."
                                                
                                            case .errorCodeInvalidEmail:
                                                errorText = "이메일이 올바르지 않습니다."
                                                
                                            case .errorCodeWeakPassword:
                                                errorText = "비밀번호가 약합니다."
                                                
                                            default:
                                                errorText = "서버에 접속하지 못 하였습니다."
                                            }
                                            self.spinner.stopAnimating()
                                            self.displayBanner(desc: errorText)
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
                                                errorText = "이메일이 이미 사용 중입니다."
                                                
                                            case .errorCodeInvalidEmail:
                                                errorText = "이메일이 올바르지 않습니다."
                                                
                                            case .errorCodeWeakPassword:
                                                errorText = "비밀번호가 약합니다."
                                                
                                            default:
                                                errorText = "서버에 접속하지 못 하였습니다."
                                            }
                                            self.spinner.stopAnimating()
                                            self.displayBanner(desc: errorText)
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
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isUserInteractionEnabled = true
        popupView.layer.cornerRadius = 5
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.clear.cgColor
        
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
            textField.lineColor = Color.lightGray
        }
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
    
    func animateRemovePopup() {

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 2.0,
                       options: .curveEaseOut,
                       animations: {
                        self.popupView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                        self.view.alpha = 0
        },
                       completion: { (finished: Bool) in
                                    self.view.removeFromSuperview()
        })


    }
    
    func animatePopup()
    {
        popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.popupView.transform = .identity
                        self.popupView.alpha = 1
            },
                       completion: nil)

    }
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.popupView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.popupView.contentInset = contentInset
        keyboardShown = true
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.popupView.contentInset = contentInset
        keyboardShown = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        setupViews()
        self.hideKeyboardWhenTappedAround()
        animatePopup()
        
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !keyboardShown {
            if !self.popupView.frame.contains((touches.first?.location(in: self.view))!) {
                closePopup(sender: self)
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

extension CreateEmail: UITextFieldDelegate {
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

}
