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

    @IBOutlet weak var accountIntro: UnderlinedLabel!
    @IBOutlet weak var accountDesc: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5
            containerView.layer.borderWidth = 5
            containerView.layer.borderColor = UIColor.clear.cgColor
        }
    }
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
    
    func setupViews() {
        let text = "계정을 만들면 아르카나 정보 수정 권한이 주어지고\n여러 기기를 사용할 경우 데이터가 유지됩니다."
        let highlightText = "아르카나 정보 수정 권한"
        let range = (text as NSString).range(of: highlightText)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: darkSalmonColor , range: range)
        
        self.accountDesc.attributedText = attributedString
        
        accountIntro.text = "사용자 계정에 대해"
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
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
