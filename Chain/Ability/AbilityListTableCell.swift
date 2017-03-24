//
//  AbilityListTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

enum AbilityMenu: String {
    case ability
    case kizuna
}

class AbilityListTableCell: BaseCollectionViewCell {

    var primaryAbilities = [Ability]()
    var statusAbilities = [Ability]()
    var areaAbilities = [Ability]()
    
    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AbilityListCell")
        
    }

}

extension AbilityListTableCell: UITableViewDelegate, UITableViewDataSource {
    
    enum Section: Int {
        case primary
        case status
        case area
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .primary:
            return primaryAbilities.count
        case .status:
            return statusAbilities.count
        case .area:
            return areaAbilities.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .primary:
            return AbilitySectionHeader(sectionTitle: "메인 어빌")
        case .status:
            return AbilitySectionHeader(sectionTitle: "상태 이상")
        case .area:
            return AbilitySectionHeader(sectionTitle: "지형 특효")
            
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "AbilityListCell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        
        switch section {
            
        case .primary:
            cell.textLabel?.text = primaryAbilities[indexPath.row].getKR()
        case .status:
            cell.textLabel?.text = statusAbilities[indexPath.row].getKR()
        case .area:
            cell.textLabel?.text = areaAbilities[indexPath.row].getKR()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
//        guard let selectedAbilityType = tableDelegate?.selectedIndex else { return }
        guard let abilityMenu = collectionViewDelegate?.abilityMenu, let section = Section(rawValue: indexPath.section), let row = tableView.indexPathForSelectedRow?.row else { return }
        
        var abilityKR = ""
        var abilityEN = ""
        
        switch section {
        case .primary:
            abilityKR = primaryAbilities[row].getKR()
            abilityEN = primaryAbilities[row].getEN()
        case .status:
            abilityKR = statusAbilities[row].getKR()
            abilityEN = statusAbilities[row].getEN()
        case .area:
            abilityKR = areaAbilities[row].getKR()
            abilityEN = areaAbilities[row].getEN()
            
        }
        
        let abilityName = (abilityKR, abilityEN)
        let abilityVC = MenuBarViewController(abilityType: abilityName, abilityMenu: abilityMenu)
        
        collectionViewDelegate?.navigationController?.pushViewController(abilityVC, animated: true)
    
    }
    
}
