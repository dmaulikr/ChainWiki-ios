//
//  AbilityListTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListTableCell: BaseCollectionViewCell {

    var pageIndex: Int!
    // Choose one of the below from parent, then designate which one this cell should use!
    var primaryAbilities = [Ability]()
    var statusAbilities = [Ability]()
    var areaAbilities = [Ability]()
    
    override func setupViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AbilityListCell", bundle: nil), forCellReuseIdentifier: "abilityListCell")
        
    }

}

enum Section: Int {
    case Primary
    case Status
    case Area
}
extension AbilityListTableCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return primaryAbilities.count
        case 1:
            return statusAbilities.count
        default:
            return areaAbilities.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .Primary:
            return AbilitySectionHeader(sectionTitle: "메인 어빌")
        case .Status:
            return AbilitySectionHeader(sectionTitle: "상태 이상")
        case .Area:
            return AbilitySectionHeader(sectionTitle: "지형 특효")
            
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityListCell") as! AbilityListCell
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .Primary:
            cell.abilityName.text = primaryAbilities[indexPath.row].getKR()
//            cell.abilityImage.image = primaryAbilities[indexPath.row].getImage()
        case .Status:
            cell.abilityName.text = statusAbilities[indexPath.row].getKR()
//            cell.abilityImage.image = statusAbilities[indexPath.row].getImage()
        case .Area:
            cell.abilityName.text = areaAbilities[indexPath.row].getKR()
//            cell.abilityImage.image = areaAbilities[indexPath.row].getImage()
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        guard let selectedAbilityType = tableDelegate?.selectedIndex else { return }
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        var abilityKR = ""
        var abilityEN = ""
        
        switch section {
        case .Primary:
            abilityKR = primaryAbilities[tableView.indexPathForSelectedRow!.row].getKR()
            abilityEN = primaryAbilities[tableView.indexPathForSelectedRow!.row].getEN()
        case .Status:
            abilityKR = statusAbilities[tableView.indexPathForSelectedRow!.row].getKR()
            abilityEN = statusAbilities[tableView.indexPathForSelectedRow!.row].getEN()
        case .Area:
            abilityKR = areaAbilities[tableView.indexPathForSelectedRow!.row].getKR()
            abilityEN = areaAbilities[tableView.indexPathForSelectedRow!.row].getEN()
            
        }
        let abilityName = (abilityKR, abilityEN)
        let abilityVC = CollectionViewWithMenu(abilityType: abilityName, selectedIndex: selectedAbilityType)
        
        tableDelegate?.navigationController?.pushViewController(abilityVC, animated: true)

    
    }
    
}
