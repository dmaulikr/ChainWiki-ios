//
//  ArcanaDetailEdit.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

protocol EditDelegate {
    func edited(_ cell: ArcanaDetailEditCell)
    func scrollUp(_ cell: ArcanaDetailEditCell)
}

class ArcanaDetailEdit: UIViewController, DisplayBanner {

    let keys = ["한글 이름", "한글 호칭", "일어 이름", "일어 호칭", "스킬 1 이름", "스킬 1 마나", "스킬 1 설명", "스킬 2 이름", "스킬 2 마나", "스킬 2 설명", "스킬 3 이름", "스킬 3 마나", "스킬 3 설명", "어빌 1 이름", "어빌 1 설명", "어빌 2 이름", "어빌 2 설명", "파티 어빌", "인연 이름", "인연 코스트", "인연 설명", "출현 장소"]
    
    let firebaseKeys = ["nameKR", "nicknameKR", "nameJP", "nicknameJP", "skillName1", "skillMana1", "skillDesc1", "skillName2", "skillMana2", "skillDesc2", "skillName3", "skillMana3", "skillDesc3", "abilityName1", "abilityDesc1", "abilityName2", "abilityDesc2", "partyAbility", "kizunaName", "kizunaCost", "kizunaDesc", "tavern"]
    
    let arcana: ArcanaEdit
    var edits = [String : String]()
    var originalAttributes = [String]()
    
    var rowBeingEdited : Int? = nil
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        tableView.register(ArcanaDetailEditCell.self, forCellReuseIdentifier: "ArcanaDetailEditCell")
        
        return tableView
    }()

    init(arcana: Arcana) {
        self.arcana = ArcanaEdit(arcana)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        setupKeyboardObservers()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("ArcanaEditView", screenClass: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        tableViewBottomAnchor?.isActive = true
        
    }
    
    func setupNavBar() {
        
        title = "아르카나 수정"
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton

    }
    
    func setupKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func save() {

        let alertController = UIAlertController(title: "수정 확인", message: "수정하시겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            
            if self.edits.count == 0 {
                self.displayBanner(formType: .noEdits, color: Color.googleRed)
            }
            else {
                self.backTwo()
                self.uploadArcana()
            }
        })
        alertController.addAction(defaultAction)
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })
        
        
    }
    
    func uploadArcana() {
        
        // Process the edit date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = format.string(from: date)
        
        
        let arcanaID = arcana.getUID()
        let arcanaRef = FIREBASE_REF.child("arcanaEdit").child(arcanaID)
        let autoID =  arcanaRef.childByAutoId().key
        // childchanged to update single arcana values
        for (key, value) in edits {
            
            let originalRef = FIREBASE_REF.child("arcana").child(arcanaID).child(key)
            let editsRef = arcanaRef.child(autoID)
            let editsPreviousRef = editsRef.child("previous").child(key)
            let editsUpdateRef = editsRef.child("update").child(key)
            // move old values to edit ref
            originalRef.observeSingleEvent(of: .value, with: { snapshot in
                
                editsPreviousRef.setValue(snapshot.value)
                
                // Moved old data, now replace old data with user's edit
                if let id = defaults.getUID() {
                    editsRef.child("editorUID").setValue(id)
                }
                
                editsUpdateRef.setValue(value)
                originalRef.setValue(value)
                
                if let nick = defaults.getName() {
                    editsRef.child("nickname").setValue(nick)
                }
                else {
                    editsRef.child("nickname").setValue("소중한 첸클 유저")
                }
                editsRef.child("date").setValue(dateString)
                editsRef.child("uid").setValue(autoID)
                
                guard let nameKR = self.arcana.getNameKR() else { return }
                Analytics.logEvent("SuccessfullyEditedArcana", parameters: [
                    "name": nameKR as NSObject,
                    "arcanaID": self.arcana.getUID() as NSObject
                    ])
                
            })
        }

    }

    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        _ = navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }
    
    var tableViewBottomAnchor: NSLayoutConstraint?
    
    func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        tableViewBottomAnchor?.constant = -keyboardFrame.height
        UIView.animate(withDuration: keyboardDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        guard let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        tableViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }

}

extension ArcanaDetailEdit: EditDelegate {
    
    func edited(_ cell: ArcanaDetailEditCell) {
        
        guard let editedText = cell.arcanaAttributeTextView.text, let indexPath = tableView.indexPath(for: cell), let row = Row(rawValue: indexPath.row) else { return }
        
        let key = firebaseKeys[indexPath.row]
        
        switch row {
        case .nameKR:
            arcana.setNameKR(editedText)
        case .nicknameKR:
            arcana.setNicknameKR(editedText)
        case .nameJP:
            arcana.setNameJP(editedText)
        case .nicknameJP:
            arcana.setNicknameJP(editedText)
        case .skillname1:
            arcana.setSkillName1(editedText)
        case .skillmana1:
            arcana.setSkillMana1(editedText)
        case .skilldesc1:
            arcana.setSkillDesc1(editedText)
        case .skillname2:
            arcana.setSkillName2(editedText)
        case .skillmana2:
            arcana.setSkillMana2(editedText)
        case .skilldesc2:
            arcana.setSkillDesc2(editedText)
        case .skillname3:
            arcana.setSkillName3(editedText)
        case .skillmana3:
            arcana.setSkillMana3(editedText)
        case .skilldesc3:
            arcana.setSkillDesc3(editedText)
        case .abilityname1:
            arcana.setAbilityName1(editedText)
        case .abilitydesc1:
            arcana.setAbilityDesc1(editedText)
        case .abilityname2:
            arcana.setAbilityName2(editedText)
        case .abilitydesc2:
            arcana.setAbilityDesc2(editedText)
        case .partyability:
            arcana.setPartyAbility(editedText)
        case .kizunaname:
            arcana.setKizunaName(editedText)
        case .kizunacost:
            arcana.setKizunaCost(editedText)
        case .kizunadesc:
            arcana.setKizunaDesc(editedText)
        case .tavern:
            arcana.setTavern(editedText)
        }
        edits.updateValue(editedText, forKey: key)
        
    }
    
    func scrollUp(_ cell: ArcanaDetailEditCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
}

extension ArcanaDetailEdit: UITableViewDelegate, UITableViewDataSource {

    fileprivate enum Row: Int {
        case nameKR
        case nicknameKR
        case nameJP
        case nicknameJP
        case skillname1
        case skillmana1
        case skilldesc1
        case skillname2
        case skillmana2
        case skilldesc2
        case skillname3
        case skillmana3
        case skilldesc3
        case abilityname1
        case abilitydesc1
        case abilityname2
        case abilitydesc2
        case partyability
        case kizunaname
        case kizunacost
        case kizunadesc
        case tavern
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaDetailEditCell") as! ArcanaDetailEditCell
        cell.editDelegate = self
        cell.arcanaAttributeTextView.tag = indexPath.row
        cell.arcanaAttributeTextView.contentInset = UIEdgeInsetsMake(-8,0,0,-8)    // very hacky ui adjusting
        cell.isUserInteractionEnabled = true
        
        cell.arcanaKeyLabel.text = keys[indexPath.row]

        switch row {
        case .nameKR:
            cell.arcanaAttributeTextView.text = arcana.getNameKR()
        case .nicknameKR:
            cell.arcanaAttributeTextView.text = arcana.getNicknameKR()
        case .nameJP:
            cell.arcanaAttributeTextView.text = arcana.getNameJP()
        case .nicknameJP:
            cell.arcanaAttributeTextView.text = arcana.getNicknameJP()
        case .skillname1:
            cell.arcanaAttributeTextView.text = arcana.getSkillName1()
        case .skillmana1:
            cell.arcanaAttributeTextView.text = arcana.getSkillMana1()
        case .skilldesc1:
            cell.arcanaAttributeTextView.text = arcana.getSkillDesc1()
            
        case .skillname2, .skillmana2, .skilldesc2:
            if arcana.getSkillCount() == "1" {
                cell.isUserInteractionEnabled = false
                cell.arcanaAttributeTextView.text = nil
            }
            else {
                switch row {
                case .skillname2:
                    cell.arcanaAttributeTextView.text = arcana.getSkillName2()
                case .skillmana2:
                    cell.arcanaAttributeTextView.text = arcana.getSkillMana2()
                case .skilldesc2:
                    cell.arcanaAttributeTextView.text = arcana.getSkillDesc2()
                default:
                    break
                }
                
            }
        case .skillname3, .skillmana3, .skilldesc3:
            if arcana.getSkillCount() != "3" {
                cell.isUserInteractionEnabled = false
                cell.arcanaAttributeTextView.text = nil
            }
            else {
                switch row {
                case .skillname3:
                    cell.arcanaAttributeTextView.text = arcana.getSkillName3()
                case .skillmana3:
                    cell.arcanaAttributeTextView.text = arcana.getSkillMana3()
                case .skilldesc3:
                    cell.arcanaAttributeTextView.text = arcana.getSkillDesc3()
                default:
                    break
                }
            }
            
        case .abilityname1:
            cell.arcanaAttributeTextView.text = arcana.getAbilityName1()
        case .abilitydesc1:
            cell.arcanaAttributeTextView.text = arcana.getAbilityDesc1()
        case .abilityname2:
            cell.arcanaAttributeTextView.text = arcana.getAbilityName2()
        case .abilitydesc2:
            cell.arcanaAttributeTextView.text = arcana.getAbilityDesc2()
        case .partyability:
            cell.arcanaAttributeTextView.text = arcana.getPartyAbility()
        case .kizunaname:
            cell.arcanaAttributeTextView.text = arcana.getKizunaName()
        case .kizunacost:
            cell.arcanaAttributeTextView.text = arcana.getKizunaCost()
        case .kizunadesc:
            cell.arcanaAttributeTextView.text = arcana.getKizunaDesc()
        case .tavern:
            cell.arcanaAttributeTextView.text = arcana.getTavern()

            
        }
        
        return cell
    }
    
}
