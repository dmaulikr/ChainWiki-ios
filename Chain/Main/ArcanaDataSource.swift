//
//  ArcanaDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 3/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaDataSource: NSObject, UITableViewDataSource {

    var arcanaArray: [Arcana]

    init(_ arcanaArray: [Arcana]) {
        self.arcanaArray = arcanaArray
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        cell.arcanaNickKR.text = nil
        cell.arcanaNickJP.text = nil
        cell.arcanaImage.image = nil

        let arcana: Arcana
        arcana = arcanaArray[indexPath.row]
        
        cell.arcanaID = arcana.getUID()
        cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .icon, sender: cell)

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
    }

}
