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
//import pop


class LoginForm: UIViewController {

    @IBOutlet weak var logo: PCView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var floatingTextFields: [SkyFloatingLabelTextFieldWithIcon]!

//    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginSpinner: NVActivityIndicatorView!
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
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var loginButton: RoundedButton! {
        didSet {
            
            loginButton.layer.shadowColor = Color.lightGray.cgColor
            loginButton.layer.shadowOffset = CGSize(width: 0, height: 1)
            loginButton.layer.shadowRadius = 0
            loginButton.layer.shadowOpacity = 1
            loginButton.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var guestButton: RoundedButton! {
        didSet {
            guestButton.tintColor = Color.textGray
        }
    }
    @IBAction func emailLogin(_ sender: AnyObject) {
        self.view.endEditing(true)
        let email = self.email.text
        let pw = password.text
        
        if (email != "" && pw != "") {
            loginSpinner.startAnimating()
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: pw!) { (user, error) in
                if error != nil {
                    
                    if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                        print(errorCode)
                        switch (errorCode) {
                            
                        case .errorCodeUserNotFound:
                            self.errorLabel.text = "계정이 틀렸습니다."

                        case .errorCodeInvalidEmail:
                            self.errorLabel.text = "계정 형식이 맞지 않습니다."
                            
                        case .errorCodeWrongPassword:
                            self.errorLabel.text = "비밀번호가 틀렸습니다."
                            
                        default:
                            self.errorLabel.text = "로그인을 못 하였습니다."
                        }
                        self.errorLabel.fadeOut(withDuration: 0.2)
                        self.errorLabel.fadeIn(withDuration: 0.5)
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
                    
                    self.changeRootVC(vc: .login)
                    

                }
                self.loginSpinner.stopAnimating()
            }
        }
        
    }

    @IBAction func createEmail(_ sender: AnyObject) {
//        self.performSegue(withIdentifier: "createEmail", sender: self)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let popup = storyboard.instantiateViewController(withIdentifier: "CreateEmail") as? CreateEmail else { return }
        self.addChildViewController(popup)
        self.view.addSubview(popup.view)
        popup.view.frame = self.view.frame
        popup.didMove(toParentViewController: self)
    }
    
    func setupViews() {
        for textField in floatingTextFields {
            
            textField.clearButtonMode = .whileEditing
            textField.backgroundColor = .clear
            textField.tintColor = Color.lightGreen
            textField.selectedIconColor = Color.lightGreen
            textField.selectedLineColor = Color.lightGreen
            textField.selectedTitleColor = Color.lightGreen
            textField.iconFont = UIFont(name: "FontAwesome", size: 15)
            textField.iconColor = Color.lightGray
            textField.errorColor = Color.darkSalmon
            textField.delegate = self
//            textField.textAlignment = .center
            textField.lineColor = Color.lightGray
        }
        errorLabel.textColor = Color.darkSalmon
        email.iconText = "\u{f0e0}"
        email.keyboardType = .emailAddress
        password.iconText = "\u{f023}"
        password.isSecureTextEntry = true
        
        
        self.title = "로그인"
//        let backButton = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
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
                self.changeRootVC(vc: .login)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupViews()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        topConstraint.constant = -self.textFieldContainerView.frame.height
//        
//        loginButton.transform = CGAffineTransform(translationX: SCREENWIDTH, y: 0)
//        guestButton.transform = CGAffineTransform(translationX: SCREENWIDTH, y: 0)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        animate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first?.location(in: self.view) else { return }
        if logo.frame.contains(touch){
            logo.bounceAnimate()
        }
    }
    func animate() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            
//            self.topConstraint.constant = 20
            self.view.layoutIfNeeded()
            
        }, completion: nil)

        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {

            self.loginButton.transform = .identity
            self.guestButton.transform = .identity
            self.view.layoutIfNeeded()
            
        }, completion: nil)

    }
    
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
                            self.errorLabel.backgroundColor = UIColor.yellow
                            self.errorLabel.textColor = UIColor.darkGray
                            self.errorLabel.text = "닉네임이 이미 존재합니다."
                            
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
                        self.errorLabel.fadeViewInThenOut(delay: 2)
                    })
                }
                else {
                    // present alert saying >= 2
                    self.errorLabel.text = "2글자 이상 입력하세요."
                    self.errorLabel.fadeViewInThenOut(delay: 2)
                    
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
    
    
    
}

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
            
            guard let uid = user?.uid else { return }
            
            self.createNick()
            defaults.setLogin(value: true)
            defaults.setUID(value: uid)
            defaults.setEditPermissions(value: true)
            defaults.setImagePermissions(value: true)
            
            getFavorites()
            
            
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        self.changeRootVC(vc: .logout)
    }
    
    
}

extension LoginForm: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = email.text {
            if let floatingLabelTextField = email {
                if(!text.isEmail) {
                    floatingLabelTextField.errorMessage = "올바른 이메일을 입력하세요."
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == email {
            textField.resignFirstResponder()
            _ = password.becomeFirstResponder()
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

