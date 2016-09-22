//
//  LoginHome.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginHome: UIViewController {

    @IBAction func guestLogin(_ sender: AnyObject) {
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            
            if error != nil {
                print("ANONYMOUS LOGIN ERROR")
            }
                
            else {
                print("GUEST LOGIN SUCCESSFUL")
                let isAnonymous = user!.isAnonymous  // true
                let uid = user!.uid
                
                UserDefaults.standard.setValue(isAnonymous, forKey: "isAnonymous")
                UserDefaults.standard.setValue(uid, forKey: "uid")
                
                self.changeRootView()
                
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
