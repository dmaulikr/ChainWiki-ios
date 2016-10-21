//
//  ArcanaDetailEdit.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaDetailEdit: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    let keys = ["한글 이름", "한글 호칭", "일어 이름", "일어 호칭", "스킬 1 이름", "스킬 1 마나", "스킬 1 설명", "스킬 2 이름", "스킬 2 마나", "스킬 2 설명", "스킬 3 이름", "스킬 3 마나", "스킬 3 설명", "어빌 1 이름", "어빌 1 설명", "어빌 2 이름", "어빌 2 설명", "인연 이름", "인연 코스트", "인연 설명"]
    
    let firebaseKeys = ["nameKR", "nickNameKR", "nameJP", "nickNameJP", "skillName1", "skillMana1", "skillDesc1", "skillName2", "skillMana2", "skillDesc2", "skillName3", "skillMana3", "skillDesc3", "abilityName1", "abilityDesc1", "abilityName1", "abilityDesc1", "kizunaName", "kizunaCost", "kizunaDesc", "skillCount"]
    var arcana: Arcana?
//    var arcanaEdit: ArcanaEdit?
    var edits = [String : String]()
    var originalAttributes = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    var rowBeingEdited : Int? = nil
    @IBOutlet weak var alert: UILabel!
    
    @IBAction func complete(_ sender: AnyObject) {

        if let row = rowBeingEdited {
            let indexPath = NSIndexPath(row: row, section: 0)
            
            let cell : ArcanaDetailEditCell? = self.tableView.cellForRow(at: indexPath as IndexPath) as! ArcanaDetailEditCell?
            
            cell?.attribute.resignFirstResponder()
        }
        
        // TODO: Confirm
        
        let alertController = UIAlertController(title: "수정 확인", message: "수정하시겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { (action:UIAlertAction) in
            self.displayBanner()
            self.uploadArcana()
        })
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })
        
        
    }
    
    func displayBanner() {
        if edits.count == 0 {
            alert.backgroundColor = UIColor.yellow
            alert.textColor = UIColor.darkGray
            alert.text = "수정된 정보가 없었습니다."
        }
        else {
//            alert.backgroundColor = Color.salmon
//            alert.textColor = UIColor.white
//            alert.text = "아르카나 수정 완료!"
            backTwo()
        }
        
        alert.fadeViewInThenOut(delay: 2)
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
            
            if let arcana = arcana {
                let uid = arcana.uid
                
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
                        editsRef.child("date").setValue(dateString)
                        editsRef.child("uid").setValue(id)
                        
                    })
                }
            }
            
        }

    }
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaDetailEditCell") as! ArcanaDetailEditCell
        cell.attribute.delegate = self
        cell.isUserInteractionEnabled = true
        guard let arcana = arcana else {
            return UITableViewCell()
        }
        

        cell.key.text = keys[indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            cell.attribute.text = arcana.nameKR
        case 1:
            cell.attribute.text = arcana.nickNameKR
        case 2:
            cell.attribute.text = arcana.nameJP
        case 3:
            cell.attribute.text = arcana.nickNameJP
        case 4:
            cell.attribute.text = arcana.skillName1
        case 5:
            cell.attribute.text = arcana.skillMana1
        case 6:
            cell.attribute.text = arcana.skillDesc1
        case 7,8,9:
            if arcana.skillCount == "1" {
                cell.isUserInteractionEnabled = false
                cell.attribute.text = nil
            }
            else {
                switch indexPath.row {
                case 7:
                    cell.attribute.text = arcana.skillName2
                case 8:
                    cell.attribute.text = arcana.skillMana2
                default:
                    cell.attribute.text = arcana.skillDesc2
                }
                
            }
        case 10,11,12:
            if arcana.skillCount != "3" {
                cell.isUserInteractionEnabled = false
                cell.attribute.text = nil
            }
            else {
                switch indexPath.row {
                case 10:
                    cell.attribute.text = arcana.skillName3
                case 11:
                    cell.attribute.text = arcana.skillMana3
                default:
                    cell.attribute.text = arcana.skillDesc3
                }
            }
            
        case 13:
            cell.attribute.text = arcana.abilityName1
        case 14:
            cell.attribute.text = arcana.abilityDesc1
        case 15:
            cell.attribute.text = arcana.abilityName2
        case 16:
            cell.attribute.text = arcana.abilityDesc2
        case 17:
            cell.attribute.text = arcana.kizunaName
        case 18:
            cell.attribute.text = arcana.kizunaCost
        default:
            cell.attribute.text = arcana.kizunaDesc
            
        }
        
        cell.attribute.tag = indexPath.row
        cell.attribute.delegate = self
        cell.attribute.contentInset = UIEdgeInsetsMake(-8,0,0,-8)    // very hacky ui adjusting
        return cell
    }

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
        print(edits["\(firebaseKeys[row])"])
        
        rowBeingEdited = nil
        
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func setupViews() {
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 5
        alert.layer.borderWidth = 1
        alert.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "ArcanaDetailEditCell", bundle: nil), forCellReuseIdentifier: "arcanaDetailEditCell")
        if let arcana = arcana {
            originalAttributes = arcana.populateArray()

        }

        self.title = arcana?.nameKR
        self.hideKeyboardWhenTappedAround()
        // count number of attributes the arcana has
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }

}

