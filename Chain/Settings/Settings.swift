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

class Settings: UIViewController, DisplayBanner {

    let sectionTitles = ["앱 설정", "계정", "소개", "지원"]
    let appSection = ["이미지 다운로드 허용"]
    let accountSection = ["닉네임 변경"]
    let aboutSection = ["사이트 가기", "출처"]
    let supportSection = ["이메일 문의"]
    
    var hasEmail = false

    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
    
        tableView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedSectionHeaderHeight = 50
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(ImageToggleCell.self, forCellReuseIdentifier: "ImageToggleCell")
        
        return tableView
    }()

    let activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballScaleRippleMultiple, color: Color.darkSalmon, padding: 0)
        return activityIndicator
    }()
    
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logout))
        return button
    }()
    
    init() {
        if defaults.canEdit() {
            hasEmail = true
        }
        else {
            hasEmail = false
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedRow, animated: true)
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        title = "설정"
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        activityIndicator.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        activityIndicator.anchorCenterSuperview()
        
    }
    
    func setupNavBar() {
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logout() {
        
        let alert = UIAlertController(title: "잠깐!", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            // Remove the user's uid from storage.
            defaults.setValue(nil, forKey: "uid")
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            defaults.synchronize()
            
            self.changeRootVC(vc: .logout)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
        }

    }
    
    func sendEmail() {
        
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
    
    func changeNick() {
        
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
                    self.activityIndicator.startAnimating()
                    let ref = FIREBASE_REF.child("nickName").child(nick)
                    
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        if snapshot.exists() {
                            
                            self.displayBanner(formType: .nicknameAlreadyInUse, color: .red)
                        }
                        else {
                            
                            // upload to firebase
                            
                            let user = Auth.auth().currentUser
                            if let user = user {
                                let changeRequest = user.createProfileChangeRequest()
                                print("DISPLAYNAME WILL CHANGE TO \(nick)")
                                changeRequest.displayName = nick
                                changeRequest.commitChanges { error in
                                      
                                    if let _ = error {
                                        // An error happened.
                                    } else {
                                        // Profile updated.
                                        let nickRef = FIREBASE_REF.child("nickName").child(nick)
                                        nickRef.setValue(true)
                                        if userNick != "" {
                                            let oldNickRef = FIREBASE_REF.child("nickName").child(userNick)
                                            oldNickRef.removeValue()
                                        }
                                        
                                        defaults.setName(value: nick)
                                    }
                                }
                            }
                        }
                        self.activityIndicator.stopAnimating()
                        
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
        
        present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
            guard let selectedRow = self.tableView.indexPathForSelectedRow else { return }
            self.tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func goEmail() {
        let vc = CreateEmail(signedIn: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSite() {
        guard let url = URL(string: "https://chainchronicle-ea233.firebaseapp.com/about") else { return }
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        present(vc, animated: true)
    }
    
    func openLicenses() {
        let vc = LicensesViewController()
        vc.loadPlist(Bundle.main, resourceName: "Credits")
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension Settings: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case app
        case account
        case about
        case support
    }
    
    private enum AppRow: Int {
        case imageToggle
        case viewPref
        case notifications
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .app:
            return SectionHeader(sectionTitle: "앱 설정")
        case .account:
            return SectionHeader(sectionTitle: "계정")
        case .about:
            return SectionHeader(sectionTitle: "소개")
        case .support:
            return SectionHeader(sectionTitle: "지원")

        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .app:
            return 3
        case .account:
            return accountSection.count
        case .about:
            return aboutSection.count
        case .support:
            return supportSection.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .app:
            
            guard let row = AppRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            switch row {
                
            case .imageToggle:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageToggleCell") as! ImageToggleCell
                
                // have a toggle for image downloads. should be a different cell
                cell.selectionStyle = .none
                
                if defaults.getImagePermissions() {
                    cell.imageToggle.isOn = true
                }
                else {
                    cell.imageToggle.isOn = false
                }
                cell.titleLabel.text = appSection[indexPath.row]
                cell.icon.image = #imageLiteral(resourceName: "imageDownload")
                
                return cell
                
            case .viewPref:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
                cell.icon.image = #imageLiteral(resourceName: "imageDownload")
                cell.titleLabel.text = "아르카나 이미지 유형 선택"
                return cell
                
            case .notifications:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
                cell.icon.image = #imageLiteral(resourceName: "notification")
                cell.titleLabel.text = "푸시 알림 설정"
                return cell
            }
            
            
        case .account, .about, .support:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            
            switch section {
            case .account:
                if hasEmail {
                    cell.icon.image = #imageLiteral(resourceName: "goEmail")
                    cell.titleLabel.text = "닉네임 변경"
                }
                else {
                    cell.icon.image = #imageLiteral(resourceName: "emailSettings")
                    cell.titleLabel.text = "이메일 전환"
                }
            case .about:
                cell.titleLabel.text = aboutSection[indexPath.row]
                
                switch indexPath.row {
                case 0:
                    cell.icon.image = #imageLiteral(resourceName: "openSite")
                    
                case 1:
                    cell.icon.image = #imageLiteral(resourceName: "licenses")
                    
                default:
                    break
                }

            case .support:
                cell.icon.image = #imageLiteral(resourceName: "emailSettings")
                cell.titleLabel.text = "이메일 문의"
            default:
                break
            }

            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
            
        case .app:
            
            guard let row = AppRow(rawValue: indexPath.row) else { return }
            
            switch row {
                
            case .imageToggle:
                break
            case .viewPref:
                let vc = SelectViewForArcanaTypeViewController()
                present(NavigationController(vc), animated: true, completion: nil)
            case .notifications:
                let vc = PushNotificationViewController(nibName: "PushNotificationViewController", bundle: nil)
                present(NavigationController(vc), animated: true, completion: nil)
            }
            
        case .account:
            
            if hasEmail {
                changeNick()
            }
            else {
                goEmail()
            }
            
        case .about:
            switch indexPath.row {
            case 0:
                openSite()
            case 1:
                openLicenses()
            default:
                break
            }
        case .support:
            sendEmail()
            
        }
        
    }
}

extension Settings: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

extension Settings: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text, text.characters.count < 2 {
            print("must be > 2")
        }
        
    }
    
}


