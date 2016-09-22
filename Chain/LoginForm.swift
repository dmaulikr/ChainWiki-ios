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


class LoginForm: UIViewController,  UITextFieldDelegate {

    @IBOutlet var floatingTextFields: [SkyFloatingLabelTextFieldWithIcon]!

    @IBOutlet weak var loginSpinner: NVActivityIndicatorView!
    @IBOutlet var containerViews: [UIView]! {
        didSet {
            for cv in containerViews {
                cv.layer.borderWidth = 5
                cv.layer.borderColor = UIColor.clear.cgColor
                cv.layer.cornerRadius = 5
            }
        }
    }
    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            email.iconText = "\u{f0e0}"

        }
    }
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            password.iconText = "\u{f023}"
            password.isSecureTextEntry = true

        }
    }
    
    @IBAction func emailLogin(_ sender: AnyObject) {
        
        let email = self.email.text
        let pw = password.text
        
        if (email != "" && pw != "") {
            loginSpinner.startAnimating()
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: pw!) { (user, error) in
                if error != nil {
                    print("There was an error logging in to this account")
                    
                    
                } else {
                    print("EMAIL LOGIN SUCCESSFUL")
                    
                    let uid = user!.uid
                    UserDefaults.standard.setValue(uid, forKey: "uid")
                    
                    self.changeRootView()
                
                }
                self.loginSpinner.stopAnimating()
            }
        }
        
    }

    @IBAction func createEmail(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "createEmail", sender: self)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = email.text {
            if let floatingLabelTextField = email {
                if(text.characters.count < 3 || !text.contains("@")) {
                    floatingLabelTextField.errorMessage = "올바른 이메일을 입력하세요."
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }

    func changeRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController")
        
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
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
