//
//  LoginHome.swift
//  Chain
//
//  Created by Jitae Kim on 9/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class LoginHome: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate, GIDSignInDelegate {

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
            email.clearButtonMode = .whileEditing
            email.tintColor = darkSalmonColor
            email.iconFont = UIFont(name: "FontAwesome", size: 15)
            email.iconText = "\u{f0e0}"
            email.iconColor = lightGrayColor
        }
    }
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            password.clearButtonMode = .whileEditing
            password.tintColor = darkSalmonColor
            password.iconFont = UIFont(name: "FontAwesome", size: 15)
            password.iconText = "\u{f023}"
            password.iconColor = lightGrayColor
            password.isSecureTextEntry = true
        }
    }
    @IBAction func googleLogin(_ sender: AnyObject) {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        if configureError != nil {
            //Handle your error
        }else {
            GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
            GIDSignIn.sharedInstance().clientID = "1008757887866-q7te1naq4r4vdnilnohb8c5nc5878lhe.apps.googleusercontent.com"
            
            
            //This did the trick for iOS 8 and the controller is presented now in iOS 8
            //We have to make allowsSignInWithBrowser false also. If we dont write this line and only write the 2nd line, then iOS 8 will not present a webview and again will take your flow outside the app in safari. So we have to write both the lines, Line 1 and Line 2

            
            GIDSignIn.sharedInstance().signIn()
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true) { () -> Void in
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true) { () -> Void in
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //Perform if user gets disconnected
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
