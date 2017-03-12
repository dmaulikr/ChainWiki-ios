//
//  ArcanaPeekPreview.swift
//  Chain
//
//  Created by Jitae Kim on 3/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPeekPreview: UIViewController {
    
    let arcana: Arcana
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        tableView.estimatedRowHeight = 160
        
//        tableView.layoutMargins = UIEdgeInsets.zero
//        tableView.separatorInset = UIEdgeInsets.zero
//        tableView.contentInset = UIEdgeInsets.zero
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(ArcanaSkillAbilityDescCell.self, forCellReuseIdentifier: "ArcanaSkillAbilityDescCell")
        tableView.register(ArcanaPeekPreviewSectionHeaderCell.self, forCellReuseIdentifier: "ArcanaPeekPreviewSectionHeaderCell")
        
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
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit(tableView: tableView)
    }
    
    func sizeHeaderToFit(tableView: UITableView) {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    func setupViews() {
        
        let header = ArcanaPeekTableViewHeader(name: arcana.getNameKR())
        tableView.tableHeaderView = header
        
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }

    override var previewActionItems: [UIPreviewActionItem] {
        
        let share = UIPreviewAction(title: "퍼가기", style: .default, handler: { (action, viewController) in
            
            generateImage(view: self.view)
        })
        
        return [share]
    }
    
}

extension ArcanaPeekPreview: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case skill
        case ability
        case partyAbility
        case kizuna
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
            
        case .skill:
            
            switch arcana.getSkillCount() {
            case "2":
                return 2
            case "3":
                return 3
            default:
                return 1
            }
            
        case .ability:
            
            if let _ = arcana.getAbilityName2() {    // has 2 abilities
                return 2
            }
            else if let _ = arcana.getAbilityName1() {  // has only 1 ability
                return 1
            }
            else {
                return 0
            }
            
        case .partyAbility:
            
            if let _ = arcana.getPartyAbility() {
                return 1
            }
            else {
                return 0
            }
            
        case .kizuna:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.numberOfRows(inSection: section) > 0 {
            return UITableViewAutomaticDimension
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.numberOfRows(inSection: section) > 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaPeekPreviewSectionHeaderCell") as! ArcanaPeekPreviewSectionHeaderCell
            
            guard let section = Section(rawValue: section) else { return nil }
            
            switch section {
            case .skill:
                cell.sectionTitleLabel.text = "스킬"
            case .ability:
                cell.sectionTitleLabel.text = "어빌리티"
            case .partyAbility:
                cell.sectionTitleLabel.text = "파티 어빌리티"
            case .kizuna:
                cell.sectionTitleLabel.text = "인연 어빌리티"
            }
            
            return cell

        }
        else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillAbilityDescCell") as! ArcanaSkillAbilityDescCell
        cell.skillAbilityDescLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        
        
        switch section {
            
        case .skill:
            
            switch indexPath.row {
            case 0:
                cell.skillAbilityDescLabel.text = "[" + arcana.getSkillMana1() + " 마나]" + arcana.getSkillDesc1()
            case 1:
                if let mana = arcana.getSkillMana2(), let skill = arcana.getSkillDesc2() {
                    cell.skillAbilityDescLabel.text = "[" + mana + " 마나]" + skill
                }
            default:
                if let mana = arcana.getSkillMana3(), let skill = arcana.getSkillDesc3() {
                    cell.skillAbilityDescLabel.text = "[" + mana + " 마나]" + skill
                }
            }
            
        case .ability:
            
            switch indexPath.row {
            case 0:
                cell.skillAbilityDescLabel.text = arcana.getAbilityDesc1()
            default:
                cell.skillAbilityDescLabel.text = arcana.getAbilityDesc2()
            }

        case .partyAbility:
            cell.skillAbilityDescLabel.text = arcana.getPartyAbility()
            
        case .kizuna:
            cell.skillAbilityDescLabel.text = arcana.getKizunaDesc()
        }
        
        
        return cell
    }

}

