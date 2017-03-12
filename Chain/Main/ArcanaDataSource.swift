//
//  ArcanaDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 3/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaDataSource: NSObject, UITableViewDataSource {

    let arcanaArray: [Arcana]
    
    init(_ arcanaArray: [Arcana]) {
        self.arcanaArray = arcanaArray
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        
        for i in cell.labelCollection {
            i.text = nil
        }
        cell.arcanaImage.image = nil
        
        let arcana = arcanaArray[indexPath.row]
        
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
        cell.arcanaUID = arcana.getUID()

        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/icon.jpg") {
            cell.arcanaImage.image = i
        }
            
        else {
            FirebaseService.dataRequest.downloadImage(uid: arcana.getUID(), sender: cell)
        }
        
        return cell
    }
}
