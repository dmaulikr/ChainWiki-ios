//
//  ArcanaDetailEdit.swift
//  Chain
//
//  Created by Jitae Kim on 9/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaDetailEdit: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func complete(_ sender: AnyObject) {

        var text = [String]()
        var cells = [UITableViewCell]()
        // assuming tableView is your self.tableView defined somewhere
        for i in 0...tableView.numberOfSections-1
        {
            for j in 0...tableView.numberOfRows(inSection: i)-1
            {
                if let cell = tableView.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) as? ArcanaDetailEditCell {
                    
                    text.append(cell.attribute.text)
                }
                
            }
        }
        
        for i in text {
            print(i)
        }

        
    }
    
    var arcana: Arcana?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 4
//            return 8
            
        case 1:
            // check for # of skills, * 3 for name, mana, desc
            return 8
            
        case 2:
            // either 0 1 2 abilities, * 3
            return 4
            
        default:
            // kizuna
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaDetailEditCell") as! ArcanaDetailEditCell
        cell.attribute.delegate = self
        
        guard let arcana = arcana else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
                
            case 0:
                cell.key.text = "한글 이름"
                cell.attribute.text = arcana.nameKR
            case 1:
                cell.key.text = "한글 호칭"
                cell.attribute.text = arcana.nickNameKR
            case 2:
                cell.key.text = "일어 호칭"
                cell.attribute.text = arcana.nameJP
            default:
                cell.key.text = "일어 호칭"
                cell.attribute.text = arcana.nickNameJP
//            case 4:
//                cell.key.text = "레어"
//                cell.attribute.text = arcana.rarity
//            case 5:
//                cell.key.text = "직업"
//            case 6:
//                cell.key.text = "소속"
//            case 7:
//                cell.key.text = "코스트"
//            default:
//                cell.key.text = "무기"
        
            }
            
        case 1:
            switch indexPath.row {
                
            case 0:
                cell.key.text = "스킬 1 이름"
                cell.attribute.text = arcana.skillName1
            case 1:
                cell.key.text = "스킬 1 마나"
                cell.attribute.text = arcana.skillMana1
            case 2:
                cell.key.text = "스킬 1 설명"
                cell.attribute.text = arcana.skillDesc1
            case 3:
                cell.key.text = "스킬 2 이름"
                cell.attribute.text = arcana.skillName2
            case 4:
                cell.key.text = "스킬 2 마나"
                cell.attribute.text = arcana.skillMana2
            case 5:
                cell.key.text = "스킬 2 설명"
                cell.attribute.text = arcana.skillDesc2
            case 6:
                cell.key.text = "스킬 3 이름"
                cell.attribute.text = arcana.skillName3
            case 7:
                cell.key.text = "스킬 3 마나"
                cell.attribute.text = arcana.skillMana3
            default:
                cell.key.text = "스킬 3 설명"
                cell.attribute.text = arcana.skillDesc3

            }
            
        case 2:
            switch indexPath.row {
                
            case 0:
                cell.key.text = "어빌 1 이름"
                cell.attribute.text = arcana.abilityName1
            case 1:
                cell.key.text = "어빌 1 설명"
                cell.attribute.text = arcana.abilityDesc1
            case 2:
                cell.key.text = "어빌 2 이름"
                cell.attribute.text = arcana.abilityName2
            default:
                cell.key.text = "어빌 2 설명"
                cell.attribute.text = arcana.abilityDesc2
                
            }
            
        default:
            switch indexPath.row {
                
            case 0:
                cell.key.text = "인연 이름"
                cell.attribute.text = arcana.kizunaName
            case 1:
                cell.key.text = "인연 코스트"
                cell.attribute.text = arcana.kizunaCost
            default:
                cell.key.text = "인연 설명"
                cell.attribute.text = arcana.kizunaDesc
                
            }
            
        }
        cell.attribute.contentInset = UIEdgeInsetsMake(-8,0,0,-8)    // very hacky ui adjusting
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
        
        self.title = arcana?.nameKR
        self.hideKeyboardWhenTappedAround()
        // count number of attributes the arcana has
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
