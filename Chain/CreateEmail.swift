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

class CreateEmail: UIViewController {

    @IBOutlet weak var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordConfirm: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nickname: SkyFloatingLabelTextFieldWithIcon!
    
    @IBAction func createEmail(_ sender: AnyObject) {

        if let email = self.email.text, let password = self.password.text {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    print("COULD NOT CREATE EMAIL")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
