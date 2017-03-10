//
//  ArcanaEditHistory.swift
//  Chain
//
//  Created by Jitae Kim on 10/13/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaEditHistory: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let keys = ["한글 이름", "한글 호칭", "일어 이름", "일어 호칭", "스킬 1 이름", "스킬 1 마나", "스킬 1 설명", "스킬 2 이름", "스킬 2 마나", "스킬 2 설명", "스킬 3 이름", "스킬 3 마나", "스킬 3 설명", "어빌 1 이름", "어빌 1 설명", "어빌 2 이름", "어빌 2 설명", "인연 이름", "인연 코스트", "인연 설명"]
    
    let firebaseKeys = ["nameKR", "nickNameKR", "nameJP", "nickNameJP", "skillName1", "skillMana1", "skillDesc1", "skillName1", "skillMana2", "skillDesc2", "skillName1", "skillMana3", "skillDesc3", "abilityName1", "abilityDesc1", "abilityName1", "abilityDesc1", "kizunaName", "kizunaCost", "kizunaDesc", "skillCount"]

    var arcana: ArcanaEditModel?
    var editor: String?
    var edits = [String : String]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func report(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "악용 신고", message: "유저를 신고하시겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { (action:UIAlertAction) in
            // upload to firebase. copy the whole directory to /report
            guard let arcana = self.arcana else {
                return
            }
            print("reporting user...")

            let editRef = arcana.arcanaRef!
            
            editRef.observeSingleEvent(of: .value, with: { snapshot in
                
                print(snapshot)
                let dict = snapshot.value as! [String : AnyObject]
                let reportRef = FIREBASE_REF.child("report")
                let id = reportRef.childByAutoId().key
                reportRef.child(id).setValue(dict)
                
                
            })
        })
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })
        
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
        cell.arcanaAttributeTextView.isUserInteractionEnabled = false

        cell.arcanaKeyLabel.text = keys[indexPath.row]
        
        /*
        switch indexPath.row {
            
        case 0:
            cell.attribute.text = arcana.getNameKR()
        case 1:
            cell.attribute.text = arcana.getNicknameKR()
        case 2:
            cell.attribute.text = arcana.getNameJP()
        case 3:
            cell.attribute.text = arcana.getNicknameJP()
        case 4:
            cell.attribute.text = arcana.getSkillName1()
        case 5:
            cell.attribute.text = arcana.getSkillMana1()
        case 6:
            cell.attribute.text = arcana.getSkillDesc1()
        case 7:
            cell.attribute.text = arcana.getSkillName2()
        case 8:
            cell.attribute.text = arcana.getSkillMana2()
        case 9:
            cell.attribute.text = arcana.getSkillDesc2()
        case 10:
            cell.attribute.text = arcana.getSkillName3()
        case 11:
            cell.attribute.text = arcana.getSkillMana3()
        case 12:
            cell.attribute.text = arcana.getSkillDesc3()
        case 13:
            cell.attribute.text = arcana.getAbilityName1()
        case 14:
            cell.attribute.text = arcana.getAbilityDesc1()
        case 15:
            cell.attribute.text = arcana.getAbilityName2()
        case 16:
            cell.attribute.text = arcana.getAbilityDesc2()
        case 17:
            cell.attribute.text = arcana.getKizunaName()
        case 18:
            cell.attribute.text = arcana.getKizunaCost()
        default:
            cell.attribute.text = arcana.getKizunaDesc()
            
        }
        */
        cell.arcanaAttributeTextView.tag = indexPath.row
        cell.arcanaAttributeTextView.contentInset = UIEdgeInsetsMake(-8,0,0,-8)    // very hacky ui adjusting
        return cell
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "ArcanaDetailEditCell", bundle: nil), forCellReuseIdentifier: "arcanaDetailEditCell")
        
//        self.title = arcana?.getNameKR()
        self.hideKeyboardWhenTappedAround()
        // count number of attributes the arcana has
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}
