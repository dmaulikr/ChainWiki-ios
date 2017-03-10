//
//  LoginHome.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    func setupViews() {
        let text = "계정이 필요한 유일한 이유는 아르카나 수정입니다. 수정할 생각이 없으면 게스트 로그인을 이용하세요."
        let highlightText = "유일한 이유"
        let range = (text as NSString).range(of: highlightText)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Color.darkSalmon , range: range)
        
        self.accountDesc.attributedText = attributedString
        
        accountIntro.text = "계정 유형 선택"
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }

    
    func guestLogin(_ sender: AnyObject) {
        
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
    
    
    func changeRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController")
        
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }

}
