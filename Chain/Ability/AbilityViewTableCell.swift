//
//  AbilityViewTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class AbilityViewTableCell: BaseCollectionViewCell {
    
    var arcanaArray = [Arcana]() {
        didSet {
            tableView.reloadData()
            if arcanaArray.count > 0 {
                tipLabel.alpha = 0
                tableView.alpha = 1
            }
            else {
                tipLabel.alpha = 1
                tableView.alpha = 0
            }
        }
    }
    
    var abilityMenu: AbilityMenu = .ability
    var showAbilityPreview = false
    
    override func setupViews() {
        super.setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        tableView.register(ArcanaAbilityPreviewCell.self, forCellReuseIdentifier: "ArcanaAbilityPreviewCell")

    }
    
}


extension AbilityViewTableCell: UITableViewDelegate, UITableViewDataSource {

    private enum Row: Int {
        case arcana
        case ability
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showAbilityPreview {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if arcanaArray.count > 0 && section == 0 {
            return SectionHeader(sectionTitle: "아르카나 수 \(arcanaArray.count)")
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        let arcana = arcanaArray[indexPath.section]

        switch row {
            
        case .arcana:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
            cell.arcanaNickKR.text = nil
            cell.arcanaNickJP.text = nil
            cell.arcanaImage.image = nil
            
            cell.arcanaID = arcana.getUID()
            cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .profile, sender: cell)
            
            // check if arcana has only name, or nickname.
            if let nnKR = arcana.getNicknameKR() {
                cell.arcanaNickKR.text = nnKR
            }
            if let nnJP = arcana.getNicknameJP() {
                cell.arcanaNickJP.text = nnJP
            }
            cell.arcanaNameKR.text = arcana.getNameKR()
            cell.arcanaNameJP.text = arcana.getNameJP()
            
            cell.arcanaRarity.text = "#\(arcana.getRarity())★"
            cell.arcanaGroup.text = "#\(arcana.getGroup())"
            cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
            
            if let a = arcana.getAffiliation() {
                if a != "" {
                    cell.arcanaAffiliation.text = "#\(a)"
                }
                
            }
            cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
            
            return cell

        case .ability:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAbilityPreviewCell") as! ArcanaAbilityPreviewCell

            switch abilityMenu {
            case .ability:
                var abilityText = ""
                if let aD1 = arcana.getAbilityDesc1() {
                    abilityText = aD1
                }
                if let aD2 = arcana.getAbilityDesc2() {
                    abilityText += "\n" + aD2
                }
                cell.abilityLabel.text = abilityText
            case .kizuna:
                cell.abilityLabel.text = arcana.getKizunaDesc()
            }
            
            return cell
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = tableView.indexPathForSelectedRow?.section else { return }
        
        let arcana = arcanaArray[section]
        let vc = ArcanaDetail(arcana: arcana)

        collectionViewDelegate?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

