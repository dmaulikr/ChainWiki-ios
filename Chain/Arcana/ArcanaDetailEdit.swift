//
//  ArcanaDetailEdit.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaDetailEdit: UIViewController, DisplayBanner {

    let keys = ["한글 이름", "한글 호칭", "일어 이름", "일어 호칭", "스킬 1 이름", "스킬 1 마나", "스킬 1 설명", "스킬 2 이름", "스킬 2 마나", "스킬 2 설명", "스킬 3 이름", "스킬 3 마나", "스킬 3 설명", "어빌 1 이름", "어빌 1 설명", "어빌 2 이름", "어빌 2 설명", "인연 이름", "인연 코스트", "인연 설명"]
    
    let firebaseKeys = ["nameKR", "nickNameKR", "nameJP", "nickNameJP", "skillName1", "skillMana1", "skillDesc1", "skillName2", "skillMana2", "skillDesc2", "skillName3", "skillMana3", "skillDesc3", "abilityName1", "abilityDesc1", "abilityName2", "abilityDesc2", "kizunaName", "kizunaCost", "kizunaDesc", "skillCount"]
    let arcana: Arcana
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
        self.arcana = arcana
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        hideKeyboardWhenTappedAround()
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setupNavBar() {
        
        title = "아르카나 수정"
        
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(save))
//        saveButton.tintColor = .lightGray
//        saveButton.isEnabled = false

        navigationItem.rightBarButtonItem = saveButton

    }
    
    func save() {

        if let row = rowBeingEdited {
            let indexPath = NSIndexPath(row: row, section: 0)
            
            let cell : ArcanaDetailEditCell? = self.tableView.cellForRow(at: indexPath as IndexPath) as! ArcanaDetailEditCell?
            
            cell?.arcanaAttributeTextView.resignFirstResponder()
        }
        
        // TODO: Confirm
        
        let alertController = UIAlertController(title: "수정 확인", message: "수정하시겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { (action:UIAlertAction) in
            
            if self.edits.count == 0 {
                
                self.displayBanner(formType: .noEdits, color: .yellow)
            }
            else {
                self.backTwo()
            }
            self.uploadArcana()
        })
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })
        
        
    }
    
    func uploadArcana() {
        // TODO: Check if there were any edits
        if edits.count != 0 {
            
            let date = Date()
            
            let format = DateFormatter()
//            format.locale = Locale(identifier: "ko_kr")
//            format.timeZone = TimeZone(abbreviation: "KST")
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateString = format.string(from: date)
            
            let uid = arcana.getUID()
            
            let arcanaRef = FIREBASE_REF.child("arcanaEdit/\(uid)")
            let id =  arcanaRef.childByAutoId().key
            // childchanged to update single arcana values
            for (key, value) in edits {
                
                let originalRef = FIREBASE_REF.child("arcana/\(uid)/\(key)")
                let editsRef = arcanaRef.child("\(id)")
                let editsPreviousRef = editsRef.child("previous/\(key)")
                let editsUpdateRef = editsRef.child("update/\(key)")
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
                        editsRef.child("nickName").setValue(nick)
                    }
                    else {
                        editsRef.child("nickName").setValue("소중한 첸클 유저")
                    }
                    editsRef.child("date").setValue(dateString)
                    editsRef.child("uid").setValue(id)
                    
                })
            }
            
            
        }

    }

    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        _ = navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }

}

extension ArcanaDetailEdit: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaDetailEditCell") as! ArcanaDetailEditCell
        cell.arcanaAttributeTextView.delegate = self
        cell.isUserInteractionEnabled = true
        
        cell.arcanaKeyLabel.text = keys[indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            cell.arcanaAttributeTextView.text = arcana.getNameKR()
        case 1:
            cell.arcanaAttributeTextView.text = arcana.getNicknameKR()
        case 2:
            cell.arcanaAttributeTextView.text = arcana.getNameJP()
        case 3:
            cell.arcanaAttributeTextView.text = arcana.getNicknameJP()
        case 4:
            cell.arcanaAttributeTextView.text = arcana.getSkillName1()
        case 5:
            cell.arcanaAttributeTextView.text = arcana.getSkillMana1()
        case 6:
            cell.arcanaAttributeTextView.text = arcana.getSkillDesc1()
        case 7,8,9:
            if arcana.getSkillCount() == "1" {
                cell.isUserInteractionEnabled = false
                cell.arcanaAttributeTextView.text = nil
            }
            else {
                switch indexPath.row {
                case 7:
                    cell.arcanaAttributeTextView.text = arcana.getSkillName2()
                case 8:
                    cell.arcanaAttributeTextView.text = arcana.getSkillMana2()
                default:
                    cell.arcanaAttributeTextView.text = arcana.getSkillDesc2()
                }
                
            }
        case 10,11,12:
            if arcana.getSkillCount() != "3" {
                cell.isUserInteractionEnabled = false
                cell.arcanaAttributeTextView.text = nil
            }
            else {
                switch indexPath.row {
                case 10:
                    cell.arcanaAttributeTextView.text = arcana.getSkillName3()
                case 11:
                    cell.arcanaAttributeTextView.text = arcana.getSkillMana3()
                default:
                    cell.arcanaAttributeTextView.text = arcana.getSkillDesc3()
                }
            }
            
        case 13:
            cell.arcanaAttributeTextView.text = arcana.getAbilityName1()
        case 14:
            cell.arcanaAttributeTextView.text = arcana.getAbilityDesc1()
        case 15:
            cell.arcanaAttributeTextView.text = arcana.getAbilityName2()
        case 16:
            cell.arcanaAttributeTextView.text = arcana.getAbilityDesc2()
        case 17:
            cell.arcanaAttributeTextView.text = arcana.getKizunaName()
        case 18:
            cell.arcanaAttributeTextView.text = arcana.getKizunaCost()
        default:
            cell.arcanaAttributeTextView.text = arcana.getKizunaDesc()
            
        }
        
        cell.arcanaAttributeTextView.tag = indexPath.row
        cell.arcanaAttributeTextView.delegate = self
        cell.arcanaAttributeTextView.contentInset = UIEdgeInsetsMake(-8,0,0,-8)    // very hacky ui adjusting
        return cell
    }
    
}

extension ArcanaDetailEdit: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        rowBeingEdited = textView.tag
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        // Update dictionary with key+attribute
        let row = textView.tag
        print(textView.text)
        print(textView.tag)
        print(originalAttributes[textView.tag])
        if textView.text != originalAttributes[textView.tag] {
            // ERROR. used to have value, but user deleted completely.
            if originalAttributes[textView.tag] != "" && textView.text == "" {
                //replace empty with original
                textView.text = originalAttributes[textView.tag]
                showAlert(title: "잠깐!", message: "정보를 삭제할 수 없습니다.")
            }
            else {
                edits.updateValue(textView.text, forKey: "\(firebaseKeys[row])")
            }
            
        }
        else {
            edits.removeValue(forKey: "\(firebaseKeys[row])")
        }
        //        print(edits["\(firebaseKeys[row])"])
        
        rowBeingEdited = nil
        
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
