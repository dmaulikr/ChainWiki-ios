//
//  AbilityListTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListTableCell: UICollectionViewCell {

//    @IBOutlet weak var tableView: UITableView!
    var tableView = UITableView()
    var pageIndex: Int!
    var abilityNames = [String]()
    var abilityImages = [UIImage]()
    var tableDelegate: AbilityListCollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.register(UINib(nibName: "AbilityListCell", bundle: nil), forCellReuseIdentifier: "abilityListCell")
        tableView.delegate = self
        tableView.dataSource = self
        
//        getAbilityList()
    }
    
    

}

extension AbilityListTableCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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

//        let flowLayout = UICollectionViewFlowLayout()
        let abilityVC = AbilityCollectionView()//collectionViewLayout: flowLayout)
        
        guard let selectedAbilityType = tableDelegate?.index else { return }
        print("selectedAbilityType \(selectedAbilityType)")
        abilityVC.selectedIndex = selectedAbilityType
        abilityVC.abilityType = abilityNames[tableView.indexPathForSelectedRow!.row]
        tableDelegate?.navigationController?.pushViewController(abilityVC, animated: true)
//        let storyboard = UIStoryboard(name: "Ability", bundle: nil)
//        guard let abilityVC = storyboard.instantiateViewController(withIdentifier: "AbilityView") as? AbilityView else { return }
//        
//        guard let selectedAbilityType = tableDelegate?.index else { return }
//        print("SELECTED ABILITY \(selectedAbilityType)")
//        abilityVC.selectedIndex = selectedAbilityType
//        abilityVC.abilityType = abilityNames[tableView.indexPathForSelectedRow!.row]
//
//        tableDelegate?.navigationController?.pushViewController(abilityVC, animated: true)
        
    
    }
    
}
