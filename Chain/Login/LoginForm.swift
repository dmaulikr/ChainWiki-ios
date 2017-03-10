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

class LoginForm: UIViewController, DisplayBanner {

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
        let textField = FloatingTextField(title: "이메일")
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextField: FloatingTextField = {
        let textField = FloatingTextField(title: "비밀번호")
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
        button.addTarget(self, action: #selector(emailLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    let facebookLoginButton: UIButton = {
        let button = loginbutton
    }()
    let googleLoginButton = GIDSignInButton()
    
    lazy var createEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.text = "이메일 계정 생성하기"
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(createEmail(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var guestLoginButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.titleLabel?.text = "게스트 로그인"
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(guestLogin(_:)), for: .touchUpInside)
        return button
    }()

    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
        return spinner
    }()
    
    @IBOutlet weak var loginLeadingConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var loginTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var containerViews: [UIView]! {
        didSet {
            for cv in containerViews {
                cv.layer.borderWidth = 5
                cv.layer.borderColor = UIColor.clear.cgColor
                cv.layer.cornerRadius = 5
            }
        }
    }
    @IBOutlet weak var textFieldContainerView: UIView!
    
    func emailLogin(_ sender: AnyObject) {
        view.endEditing(true)
        let email = self.emailTextField.text
        let pw = passwordTextField.text
        
        if (email != "" && pw != "") {
            activityIndicator.startAnimating()
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: pw!) { (user, error) in
                if error != nil {
                    
                    if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {

                        var errorText = ""
                        
                        switch (errorCode) {
                            
                        case .errorCodeUserNotFound:
                            errorText = "계정이 틀렸습니다."

                        case .errorCodeInvalidEmail:
                            errorText = "계정 형식이 맞지 않습니다."
                            
                        case .errorCodeWrongPassword:
                            errorText = "비밀번호가 틀렸습니다."
                            
                        default:
                            errorText = "서버에 접속하지 못 하였습니다."
                        }
                        
                        self.displayBanner(desc: errorText)

                    }
                    
                    
                } else {
                    
                    guard let user = user else {
                        return
                    }
                    
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

    func createEmail(_ sender: AnyObject) {
//        self.performSegue(withIdentifier: "createEmail", sender: self)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let popup = storyboard.instantiateViewController(withIdentifier: "CreateEmail") as? CreateEmail else { return }
        self.addChildViewController(popup)
        self.view.addSubview(popup.view)
        popup.view.frame = self.view.frame
        popup.didMove(toParentViewController: self)
    }
    

    func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    @IBAction func facebookLogin(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                
                if let _ = result?.grantedPermissions?.contains("email") {
                    
                        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id"]).start { (connection, result, err) in
                            
                            if err != nil {
                                return
                            }
                            
                            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                            
                            FIRAuth.auth()?.signIn(with: credentials, completion: { [unowned self]  (user, error) in
                                if let _ = error {
                                    return
                                }
                                
                                // Set nickname
                                
                                guard let user = user else {
                                    return
                                }
                                
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
                    
                    
                }
                
            }
        }
        
    }
    @IBAction func guestLogin(_ sender: Any) {
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            
            if error != nil {
                print("ANONYMOUS LOGIN ERROR")
            }
                
            else {
                print("GUEST LOGIN SUCCESSFUL")
                guard let user = user else {
                    return
                }
                
                defaults.setImagePermissions(value: true)
                defaults.setLogin(value: true)
                defaults.setUID(value: user.uid)
                self.changeRootVC(vc: .home)
            }
        }
    }
    
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
        //        facebookLoginButton.delegate = self


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
        
        logoImage.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 100)
        logoImage.anchorCenterXToSuperview()
        
        chainWikiLabel.anchor(top: logoImage.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        chainWikiLabel.anchorCenterXToSuperview()
        
        emailTextField.anchor(top: chainWikiLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 40, trailingConstant: 40, bottomConstant: 0, widthConstant: 0, heightConstant: 40)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 40)
        
        loginButton.anchor(top: passwordTextField.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 44)
        
        facebookLoginButton.anchor(top: loginButton.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 80)
        
        googleLoginButton.anchor(top: facebookLoginButton.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 44)
        
        createEmailButton.anchor(top: nil, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        guestLoginButton.anchor(top: createEmailButton.bottomAnchor, leading: emailTextField.leadingAnchor, trailing: emailTextField.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first?.location(in: self.view) else { return }
        if logoImage.frame.contains(touch){
            logoImage.bounceAnimate()
        }

    }
    
    func animate() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            
//            self.topConstraint.constant = 20
            self.view.layoutIfNeeded()
            
        }, completion: nil)

        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {

            self.loginButton.transform = .identity
            self.guestLoginButton.transform = .identity
            self.view.layoutIfNeeded()
            
        }, completion: nil)

    }
    
    /*
    func createNick() {
        print("called alert")

        
        let alert = UIAlertController(title: "닉네임 입력", message: "2글자 이상", preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {
            _ -> Void in
            let textField = alert.textFields![0] as UITextField
            if let nick = textField.text {
                if nick.characters.count >= 2 {
                    // check firebase for duplicate
                    let ref = FIREBASE_REF.child("nickName/\(nick)")
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        if snapshot.exists() {

//                            self.errorLabel.text = "닉네임이 이미 존재합니다."
                            
                        }
                        else {

                            // upload to firebase
                            
                            let user = FIRAuth.auth()?.currentUser
                            if let user = user {
                                let changeRequest = user.profileChangeRequest()
                                print("DISPLAYNAME WILL CHANGE TO \(nick)")
                                changeRequest.displayName = nick
                                changeRequest.commitChanges { error in
                                    
                                    if let _ = error {
                                        // An error happened.
                                    } else {
                                        // Profile updated.
                                        let nickRef = FIREBASE_REF.child("nickName/\(nick)")
                                        nickRef.setValue(true)
                                        
                                        defaults.setName(value: nick)
                                        self.changeRootVC(vc: .login)
                                    }
                                }
                            }
                        }
                    })
                }
                else {
                    // present alert saying >= 2
//                    self.errorLabel.text = "2글자 이상 입력하세요."
                    
                }
            }
            
            // do something with textField
        }))
        

        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            
            
        })
//
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }
//        
//        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = Color.salmon

        }
    }
    
    */
    
}

/*
extension LoginForm: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            guard let uid = user?.uid else { return }
            
            defaults.setLogin(value: true)
            defaults.setUID(value: uid)
            defaults.setEditPermissions(value: true)
            defaults.setImagePermissions(value: true)
            
            getFavorites()
            
            self.changeRootVC(vc: .login)
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id"]).start { (connection, result, err) in
            
            if err != nil {
                return
            }
            print(result ?? "")
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
        
    }
    
}
 */


extension LoginForm: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { [unowned self]  (user, error) in
            if let _ = error {
                return
            }
            
            // Set nickname
            
            guard let user = user else {
                return
            }
            
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
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
//        self.changeRootVC(vc: .logout)
    }
    
    
}

extension LoginForm: UITextFieldDelegate {
    
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
            self.emailLogin(self)
        }
        return true
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.setFillColor(color.cgColor)
        bitmapContext!.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext!.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            return coloredImage
            
        } else {
            return nil
        } 
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

