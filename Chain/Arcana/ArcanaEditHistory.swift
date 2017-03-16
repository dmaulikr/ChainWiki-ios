//
//  ArcanaEditHistory.swift
//  Chain
//
//  Created by Jitae Kim on 10/13/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaEditHistory: UIViewController {

    let keys = ["한글 이름", "한글 호칭", "일어 이름", "일어 호칭", "스킬 1 이름", "스킬 1 마나", "스킬 1 설명", "스킬 2 이름", "스킬 2 마나", "스킬 2 설명", "스킬 3 이름", "스킬 3 마나", "스킬 3 설명", "어빌 1 이름", "어빌 1 설명", "어빌 2 이름", "어빌 2 설명", "파티 어빌", "인연 이름", "인연 코스트", "인연 설명", "출현 장소"]
    
    let firebaseKeys = ["nameKR", "nicknameKR", "nameJP", "nicknameJP", "skillName1", "skillMana1", "skillDesc1", "skillName2", "skillMana2", "skillDesc2", "skillName3", "skillMana3", "skillDesc3", "abilityName1", "abilityDesc1", "abilityName2", "abilityDesc2", "kizunaName", "kizunaCost", "kizunaDesc", "skillCount"]

    var arcana: ArcanaEditModel
    var editor: String?
    var edits = [String : String]()
    
    fileprivate lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.allowsSelection = false
        tableView.register(ArcanaDetailEditCell.self, forCellReuseIdentifier: "ArcanaDetailEditCell")
        
        return tableView
    }()

    init(arcana: ArcanaEditModel) {
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
        title = arcana.arcana.getNameKR()
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupNavBar() {
        let reportButton = UIBarButtonItem(title: "신고", style: .plain, target: self, action: #selector(report))
        navigationItem.rightBarButtonItem = reportButton
    }
    
    func report() {
        
        let alertController = UIAlertController(title: "악용 신고", message: "유저를 신고하시겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            // upload to firebase. copy the whole directory to /report
            let editRef = self.arcana.arcanaRef!
            
            editRef.observeSingleEvent(of: .value, with: { snapshot in
                
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

}

extension ArcanaEditHistory: UITableViewDataSource, UITableViewDelegate {

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
        
        guard let row = Row(rawValue: indexPath.row), let arcanaEdit = arcana.arcana else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaDetailEditCell") as! ArcanaDetailEditCell
        cell.arcanaAttributeTextView.isUserInteractionEnabled = false
        
        cell.arcanaKeyLabel.text = keys[indexPath.row]
        
        
        switch row {
        case .nameKR:
            cell.arcanaAttributeTextView.text = arcanaEdit.getNameKR()
        case .nicknameKR:
            cell.arcanaAttributeTextView.text = arcanaEdit.getNicknameKR()
        case .nameJP:
            cell.arcanaAttributeTextView.text = arcanaEdit.getNameJP()
        case .nicknameJP:
            cell.arcanaAttributeTextView.text = arcanaEdit.getNicknameJP()
        case .skillname1:
            cell.arcanaAttributeTextView.text = arcanaEdit.getSkillName1()
        case .skillmana1:
            cell.arcanaAttributeTextView.text = arcanaEdit.getSkillMana1()
        case .skilldesc1:
            cell.arcanaAttributeTextView.text = arcanaEdit.getSkillDesc1()
            
        case .skillname2, .skillmana2, .skilldesc2:
            if arcanaEdit.getSkillCount() == "1" {
                cell.isUserInteractionEnabled = false
                cell.arcanaAttributeTextView.text = nil
            }
            else {
                switch row {
                case .skillname2:
                    cell.arcanaAttributeTextView.text = arcanaEdit.getSkillName2()
                case .skillmana2:
                    cell.arcanaAttributeTextView.text = arcanaEdit.getSkillMana2()
                case .skilldesc2:
                    cell.arcanaAttributeTextView.text = arcanaEdit.getSkillDesc2()
                default:
                    break
                }
                
            }
        case .skillname3, .skillmana3, .skilldesc3:
            if arcanaEdit.getSkillCount() != "3" {
                cell.isUserInteractionEnabled = false
                cell.arcanaAttributeTextView.text = nil
            }
            else {
                switch row {
                case .skillname3:
                    cell.arcanaAttributeTextView.text = arcanaEdit.getSkillName3()
                case .skillmana3:
                    cell.arcanaAttributeTextView.text = arcanaEdit.getSkillMana3()
                case .skilldesc3:
                    cell.arcanaAttributeTextView.text = arcanaEdit.getSkillDesc3()
                default:
                    break
                }
            }
            
        case .abilityname1:
            cell.arcanaAttributeTextView.text = arcanaEdit.getAbilityName1()
        case .abilitydesc1:
            cell.arcanaAttributeTextView.text = arcanaEdit.getAbilityDesc1()
        case .abilityname2:
            cell.arcanaAttributeTextView.text = arcanaEdit.getAbilityName2()
        case .abilitydesc2:
            cell.arcanaAttributeTextView.text = arcanaEdit.getAbilityDesc2()
        case .kizunaname:
            cell.arcanaAttributeTextView.text = arcanaEdit.getKizunaName()
        case .kizunacost:
            cell.arcanaAttributeTextView.text = arcanaEdit.getKizunaCost()
        case .kizunadesc:
            cell.arcanaAttributeTextView.text = arcanaEdit.getKizunaDesc()
        case .tavern:
            cell.arcanaAttributeTextView.text = arcanaEdit.getTavern()
        default:
            break
            
        }
        
        cell.arcanaAttributeTextView.contentInset = UIEdgeInsetsMake(-8,0,0,-8)    // very hacky ui adjusting
        return cell
    }

}
