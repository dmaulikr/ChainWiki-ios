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
    var abilityNames = [String]()
    var abilityImages = [UIImage]()
    
    override func setupViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AbilityListCell", bundle: nil), forCellReuseIdentifier: "abilityListCell")
        
    }

}

extension AbilityListTableCell: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityListCell") as! AbilityListCell
        cell.abilityName.text = abilityNames[indexPath.row]
        cell.abilityImage.image = abilityImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let selectedAbilityType = tableDelegate?.selectedIndex else { return }
        
        
        let abilityVC = CollectionViewWithMenu(abilityType: abilityNames[tableView.indexPathForSelectedRow!.row], selectedIndex: selectedAbilityType)
        
        tableDelegate?.navigationController?.pushViewController(abilityVC, animated: true)

    
    }
    
}
