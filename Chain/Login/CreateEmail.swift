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
    
    lazy var emailTextField: FloatingTextField = {
        let textField = FloatingTextField(.email)
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextField: FloatingTextField = {
        let textField = FloatingTextField(.password)
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordConfirmTextField: FloatingTextField = {
        let textField = FloatingTextField(.passwordConfirm)
        textField.delegate = self
        return textField
    }()
    
    lazy var nicknameTextField: FloatingTextField = {
        let textField = FloatingTextField(.nickname)
        textField.delegate = self
        return textField
    }()
    
    lazy var registerButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.backgroundColor = Color.lightGreen
        button.addTarget(self, action: #selector(createEmail), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
        return spinner
    }()
    
    var signedIn = false
    var keyboardShown = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(signedIn: Bool) {
        self.signedIn = signedIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(registerButton)
        view.addSubview(activityIndicator)
        
        emailTextField.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        passwordConfirmTextField.anchor(top: passwordTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        nicknameTextField.anchor(top: passwordConfirmTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        registerButton.anchor(top: nicknameTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        activityIndicator.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        activityIndicator.anchorCenterXToSuperview()
    }
    
    func setupNavBar() {
        
        title = "이메일 계정 생성"
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        let registerbutton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(createEmail))
//        saveButton.tintColor = .lightGray
//        saveButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = registerbutton
        
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func createEmail() {

        view.endEditing(true)
        var formType: BannerFormType?
        
        if let email = emailTextField.text, let password = passwordTextField.text, let passwordConfirm = passwordConfirmTextField.text, let nickname = nicknameTextField.text {
        
            if password == "" || passwordConfirm == "" {
                formType = .shortPassword
            }
            
            else if nickname == "" || nickname.characters.count < 2 {
                formType = .shortNickname
            }
                
            else if password != passwordConfirm {
                formType = .incorrectPassword
            }
                
            else {
                    activityIndicator.startAnimating()
                
                    let nickNameRef = FIREBASE_REF.child("nickName").child(nickname)
                    nickNameRef.observeSingleEvent(of: .value, with: { snapshot in
                        
                        if snapshot.exists() {
//                            formType = .nicknameAlreadyInUse
                            self.activityIndicator.stopAnimating()
                            self.displayBanner(formType: .nicknameAlreadyInUse)
                        }
                        else {
                            
                            if self.signedIn == true {
                                //link account to new email
//                                print("linking to email...")
                                
                                let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
                                
                                FIRAuth.auth()?.currentUser?.link(with: credential) { (user, error) in
                                    
                                    self.activityIndicator.stopAnimating()

                                    if error != nil {
                                        print("ERROR LINKING TO EMAIL")

                                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                            switch errorCode {
                                                
                                            case .errorCodeEmailAlreadyInUse:
                                                formType = .emailAlreadyInUse
                                                
                                            case .errorCodeInvalidEmail:
                                                formType = .invalidEmail
                                                
                                            case .errorCodeWeakPassword:
                                                formType = .weakPassword
                                                
                                            default:
                                                formType = .serverError
                                            }
                                            
                                            if let formType = formType {
                                                self.displayBanner(formType: formType)
                                            }
                                        }
                                        
                                    }
                                    else {
                                        print("successfully linked email!")
                                        guard let user = user else { return }
                                         
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
                                        
                                        self.changeRootVC(vc: .home)
                                        
                                    }
                                }
                                
                            }
                            
                            else {
                                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                                    
                                    self.activityIndicator.stopAnimating()

                                    if error != nil {
                                        
                                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                            switch errorCode {
                                                
                                            case .errorCodeEmailAlreadyInUse:
                                                formType = .emailAlreadyInUse
                                                
                                            case .errorCodeInvalidEmail:
                                                formType = .invalidEmail
                                                
                                            case .errorCodeWeakPassword:
                                                formType = .weakPassword
                                                
                                            default:
                                                formType = .serverError
                                            }
                                            if let formType = formType {
                                                self.displayBanner(formType: formType)
                                            }
                                        }
                                    }
                                        
                                    else {
                                        
                                        print("EMAIL ACCOUNT CREATED, LOGGING IN...")
                                        guard let user = user else { return }
                                        
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
                                        self.changeRootVC(vc: .home)
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    })
                    
                }
            
            if let form = formType {
                displayBanner(formType: form)
            }
            
            
            }
   
    }

}

extension CreateEmail: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
            
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordConfirmTextField.becomeFirstResponder()
        case passwordConfirmTextField:
            nicknameTextField.becomeFirstResponder()
        case nicknameTextField:
            createEmail()
        default:
            textField.resignFirstResponder()
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            
            switch textField {
                
            case emailTextField:
                
                if(!text.isEmail) {
                    emailTextField.errorMessage = "올바른 이메일을 입력하세요."
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    emailTextField.errorMessage = ""
                }
                
                
            case passwordTextField:
                
                if(text.characters.count < 6) {
                    passwordTextField.errorMessage = "6자 이상 입력하세요."
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    passwordTextField.errorMessage = ""
                }
                
                
            case passwordConfirmTextField:

                if text != passwordConfirmTextField.text {
                    passwordConfirmTextField.errorMessage = "비밀번호가 맞지 않습니다."
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    passwordConfirmTextField.errorMessage = ""
                }
                
                
            default:

                let ref = FIREBASE_REF.child("nickname/\(text)")
                    
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    
                    if snapshot.exists() {
                        self.nicknameTextField.errorMessage = "닉네임이 이미 존재합니다."
                    }
                        
                    else {
                        self.nicknameTextField.errorMessage = ""
                    }
                    
                })
                    
                
            }
            
        }
        
    }

}
