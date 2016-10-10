//
//  Settings.swift
//  Chain
//
//  Created by Jitae Kim on 10/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class Settings: UIViewController {

    @IBAction func logout(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "잠깐!", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.view.tintColor = salmonColor
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            // Remove the user's uid from storage.
            UserDefaults.standard.setValue(nil, forKey: "uid")
            
            try! FIRAuth.auth()!.signOut()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            UIView.transition(with: self.view.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                self.view.window!.rootViewController = initialViewController
                }, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = salmonColor
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
