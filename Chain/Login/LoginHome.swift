//
//  LoginHome.swift
//  Chain
//
//  Created by Jitae Kim on 9/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn

enum LoginProvider {
    case facebook
    case google
}

class LoginHome: UIViewController, DisplayBanner {

    let logoImage: PCView = {
        let view = PCView()
        view.backgroundColor = .white
        return view
    }()
    
    let chainWikiLabel: UILabel = {
        let label = UILabel()
        label.text = "체인크로니클 위키"
        label.textColor = Color.lightGreen
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 25)
        return label
    }()
    
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

    lazy var loginButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.backgroundColor = Color.lightGreen
        button.layer.shadowColor = Color.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(emailLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var facebookLoginButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.backgroundColor = Color.facebookBlue
        button.setTitle("페이스북 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.addTarget(self, action: #selector(facebookLogin), for: .touchUpInside)
        return button
    }()
    
    let googleLoginButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.backgroundColor = Color.googleRed
        button.setTitle("구글 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        return button
    }()

    lazy var createEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일 계정 생성하기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.addTarget(self, action: #selector(createEmail(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var guestLoginButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.setTitle("게스트 로그인", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.addTarget(self, action: #selector(guestLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
        return spinner
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        title = "로그인"
        
        view.addSubview(logoImage)
        view.addSubview(chainWikiLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(facebookLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(createEmailButton)
        view.addSubview(guestLoginButton)
        view.addSubview(activityIndicator)
        
        logoImage.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 100)
        logoImage.anchorCenterXToSuperview()
        
        chainWikiLabel.anchor(top: logoImage.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        chainWikiLabel.anchorCenterXToSuperview()
        
        emailTextField.anchor(top: chainWikiLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 40)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 40)
        
        loginButton.anchor(top: passwordTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 44)
        
        facebookLoginButton.anchor(top: loginButton.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 44)
        
        googleLoginButton.anchor(top: facebookLoginButton.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 44)
        
        createEmailButton.anchor(top: nil, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        guestLoginButton.anchor(top: createEmailButton.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 100)
        activityIndicator.anchorCenterSuperview()
        
    }
    
    @objc func emailLogin() {
        view.endEditing(true)
        let email = self.emailTextField.text
        let pw = passwordTextField.text
        
        if (email != "" && pw != "") {
            animateUserLogin(animated: true)
            
            Auth.auth().signIn(withEmail: email!, password: pw!) { (user, error) in
                if error != nil {
                    self.animateUserLogin(animated: false)
                    
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {

                        var formType: BannerFormType
                        
                        switch errorCode {
                            
                        case .userNotFound:
                            formType = .emailNotFound

                        case .invalidEmail:
                            formType = .invalidEmail
                            
                        case .wrongPassword:
                            formType = .incorrectPassword
                            
                        default:
                            formType = .serverError
                        }
                        
                        self.displayBanner(formType: formType, color: .red)

                    }
                    
                    
                } else {
                    
                    guard let user = user else { return }
                    
                    if let nickName = user.displayName {
                        defaults.setName(value: nickName)
                    }
                    defaults.setLogin(value: true)
                    defaults.setUID(value: user.uid)
                    defaults.setEditPermissions(value: true)
                    defaults.setImagePermissions(value: true)
                    
                    getFavorites()
                    
                    self.changeRootVC(vc: .home)
                    

                }
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    func firebaseLogin(loginProvider: LoginProvider, credentials: AuthCredential) {
        
        animateUserLogin(animated: true)

        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let _ = error {
                self.animateUserLogin(animated: false)
            }
            
            guard let user = user else { return }
            
            if let nickName = user.displayName {
                defaults.setName(value: nickName)
            }
            
            defaults.setLogin(value: true)
            defaults.setUID(value: user.uid)
            defaults.setEditPermissions(value: true)
            defaults.setImagePermissions(value: true)
            
            getFavorites()
            
            self.changeRootVC(vc: .home)
        })
    }
    
    @objc func googleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func facebookLogin() {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, _, let accessToken):
                print("Logged in!")
                if grantedPermissions.contains("email") {
                    
                    FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id"]).start { (connection, result, err) in
                        
                        if err != nil { return }
                        
                        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                        
                        self.firebaseLogin(loginProvider: .facebook, credentials: credentials)
                        
                    }
                }
            }
        }
        
    }
    
    @objc func createEmail(_ sender: AnyObject) {
        let vc = CreateEmail()
        present(NavigationController(vc), animated: true, completion: nil)
    }
    
    @objc func guestLogin(_ sender: Any) {
        
        animateUserLogin(animated: true)
        
        Auth.auth().signInAnonymously() { (user, error) in
            
            if error != nil {
                self.animateUserLogin(animated: false)
                print("ANONYMOUS LOGIN ERROR")
            }
                
            else {
                print("GUEST LOGIN SUCCESSFUL")
                guard let user = user else { return }
                
                defaults.setImagePermissions(value: true)
                defaults.setLogin(value: true)
                defaults.setUID(value: user.uid)
                self.changeRootVC(vc: .home)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first?.location(in: self.view) else { return }
        if logoImage.frame.contains(touch){
            logoImage.bounceAnimate()
        }
        
    }
    
    func animateUserLogin(animated: Bool) {
        
        if animated {
            view.addSubview(whiteView)
            whiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
            
            view.addSubview(activityIndicator)
            activityIndicator.anchorCenterSuperview()
            activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
            view.layoutIfNeeded()
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
            whiteView.removeFromSuperview()
        }
        
        
    }

    
}

extension LoginHome: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            return
        }
        
        guard let idToken = user.authentication.idToken, let accessToken = user.authentication.accessToken else { return }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        firebaseLogin(loginProvider: .google, credentials: credentials)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    
}

extension LoginHome: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = emailTextField.text {
            
            if(!text.isEmail) {
                emailTextField.errorMessage = "올바른 이메일을 입력하세요."
            }
            else {
                // The error message will only disappear when we reset it to nil or empty string
                emailTextField.errorMessage = ""
            }
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            textField.resignFirstResponder()
            _ = passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.emailLogin()
        }
        return true
    }
}

extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
}

func getFavorites() {
    
    let defaults = UserDefaults.standard
    if (defaults.bool(forKey: "initialLaunch")) {
        // app already launched
    }
    else {
        // This is the first launch ever
        defaults.set(true, forKey: "initialLaunch")
        defaults.synchronize()
        
        if let id = defaults.getUID() {
            
            let ref = FIREBASE_REF.child("user/\(id)/favorites")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                var uids = [String]()
                
                for child in snapshot.children {
                    let arcanaID = (child as AnyObject).key as String
                    uids.append(arcanaID)
                }
                
                defaults.set(uids, forKey: "favorites")
                defaults.synchronize()
                
            })
            
            
        }
        
    }
    
}

