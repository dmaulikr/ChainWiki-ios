//
//  Settings.swift
//  Chain
//
//  Created by Jitae Kim on 10/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import NVActivityIndicatorView
import SafariServices
import LicensesViewController

class Settings: UIViewController, UITableViewDelegate, UITableViewDataSource,  MFMailComposeViewControllerDelegate, DisplayBanner {

    let sectionTitles = ["앱 설정", "계정", "소개", "지원"]
    let appSection = ["이미지 다운로드 허용"]
    let accountSection = ["닉네임 변경"]
    let aboutSection = ["사이트 가기", "출처"]
    let supportSection = ["이메일 문의"]
    
    var hasEmail = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBAction func logout(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "잠깐!", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            // Remove the user's uid from storage.
            UserDefaults.standard.setValue(nil, forKey: "uid")
            
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
//            try! FIRAuth.auth()!.signOut()
            
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            defaults.synchronize()

            
            self.changeRootVC(vc: .logout)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
        }
        
    }

    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! SettingsSectionHeader
        header.sectionTitle.text = sectionTitles[section]
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return appSection.count
        case 1:
            return accountSection.count
        case 2:
            return aboutSection.count
        default:
            return supportSection.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsCell
        
        switch indexPath.section {
            
        case 0:
            // have a toggle for image downloads. should be a different cell
            cell.selectionStyle = .none
            if defaults.getImagePermissions() {
                cell.imageToggle.isOn = true
            }
            else {
                cell.imageToggle.isOn = false
            }
            cell.imageToggle.alpha = 1
            cell.title.text = appSection[indexPath.row]
            cell.icon.image = #imageLiteral(resourceName: "imageDownload")
            // either changeNick or linkEmail
        case 1:
            if hasEmail {
                cell.icon.image = #imageLiteral(resourceName: "goEmail")
                cell.title.text = "닉네임 변경"
            }
            else {
                cell.icon.image = #imageLiteral(resourceName: "emailSettings")
                cell.title.text = "이메일 전환"
            }
            
            
        case 2:
            cell.title.text = aboutSection[indexPath.row]
            
            switch indexPath.row {
            case 0:
                cell.icon.image = #imageLiteral(resourceName: "openSite")
                
            case 1:
                cell.icon.image = #imageLiteral(resourceName: "licenses")
                
            default:
                break
            }
            
        case 3:
            cell.icon.image = #imageLiteral(resourceName: "emailSettings")
            cell.title.text = "이메일 문의"
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 1:
            
            if hasEmail {
                // changeNick
                changeNick()
                
            }
            else {
                // go email
                goEmail()
                
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                openSite()
            case 1:
                self.performSegue(withIdentifier: "toLicenses", sender: self)
            default:
                break
            }
        case 3:
            sendEmail(self)
            
        default:
            break
            
        }

    }
    
    @IBAction func sendEmail(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["jitaekim93@gmail.com"])
            mail.setSubject("체인크로니클 위키 iOS 앱 문의")
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        tableView.backgroundColor = .white
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        // check to see which first cell to populate.
        
        if defaults.bool(forKey: "edit") == true {
            hasEmail = true
        }
        else {
            hasEmail = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text {
            if text.characters.count < 2 {
                print("must be > 2")
                
            }
        }
        
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLicenses" {
            if let destinationVC = segue.destination as? LicensesViewController {
                destinationVC.loadPlist(Bundle.main, resourceName: "Credits")
            }
        }
    }

}

extension Settings: UITextFieldDelegate {
    
    func changeNick() {
        print("called alert")
        let userNick = defaults.getName() ?? ""
        let alert = UIAlertController(title: "새로운 닉네임 입력", message: "현재: \(userNick)", preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        alert.addAction(UIAlertAction(title: "변경", style: .default, handler: {
            _ -> Void in
            let textField = alert.textFields![0] as UITextField
            if let nick = textField.text {
                if nick.characters.count >= 2 {
                    // check firebase for duplicate
                    self.spinner.startAnimating()
                    let ref = FIREBASE_REF.child("nickName/\(nick)")
                    
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        if snapshot.exists() {

                            self.displayBanner(desc: "닉네임이 이미 존재합니다.")
                        }
                        else {
                            
                            self.displayBanner(desc: "닉네임 변경 완료!", color: Color.lightGreen)
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
                                        if userNick != "" {
                                            let oldNickRef = FIREBASE_REF.child("nickName/\(userNick)")
                                            oldNickRef.removeValue()
                                        }
                                        
                                        defaults.setName(value: nick)
                                    }
                                }
                            }
                        }
                        self.spinner.stopAnimating()
                        
                    })
                }
                else {
                    // present alert saying >= 2
                }
            }
            
            // do something with textField
        }))
        
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            
            textField.placeholder = userNick
            
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
            if let selectedRow = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRow, animated: true)
            }
        }
    }
    
    
    func goEmail() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CreateEmail") as! CreateEmail
        vc.signedIn = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func openSite() {
        if let url = URL(string: "https://jitaek.github.io/ChainChronicleKoreaWiki/") {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
    }
    
}


