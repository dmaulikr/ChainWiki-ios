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
        
        if arcanaArray.count == 0 {
            cell.arcanaImage.image = #imageLiteral(resourceName: "placeholder")
            
            for i in cell.labelCollection {
                i.alpha = 0
            }
            
        }
        else {
            cell.arcanaNameKR.alpha = 0
            cell.arcanaNameJP.alpha = 0
            for i in cell.labelCollection {
                i.text = nil
                i.backgroundColor = UIColor.white
                i.alpha = 1
            }
            cell.arcanaImage.image = nil
            
            
            let arcana: Arcana

            arcana = arcanaArray[indexPath.row]
            
            // check if arcana has only name, or nickname.
            if let nnKR = arcana.getNicknameKR() {
                cell.arcanaNickKR.text = nnKR
                cell.arcanaNickKR.textColor = UIColor.black
            }
            if let nnJP = arcana.getNicknameJP() {
                
                cell.arcanaNickJP.text = nnJP
                cell.arcanaNickJP.textColor = Color.textGray
            }
            cell.arcanaNameKR.text = arcana.getNameKR()
            cell.arcanaNameKR.textColor = UIColor.black
            cell.arcanaNameJP.text = arcana.getNameJP()
            cell.arcanaNameJP.textColor = Color.textGray
            
            cell.arcanaRarity.text = "#\(arcana.getRarity())★"
            cell.arcanaRarity.textColor = Color.lightGreen
            cell.arcanaGroup.text = "#\(arcana.getGroup())"
            cell.arcanaGroup.textColor = Color.lightGreen
            cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
            cell.arcanaWeapon.textColor = Color.lightGreen
            
            if let a = arcana.getAffiliation() {
                if a != "" {
                    cell.arcanaAffiliation.text = "#\(a)"
                    cell.arcanaAffiliation.textColor = Color.lightGreen
                }
                
            }
            
            cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
            cell.numberOfViews.textColor = Color.lightGreen
            
            cell.arcanaUID = arcana.getUID()
            
            // Check cache first
            if let i = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/icon.jpg") {
                
                cell.arcanaImage.image = i
                
            }
                
            else {
                FirebaseService.dataRequest.downloadImage(uid: arcana.getUID(), sender: cell)
            }
            
        }
        
        return cell
    }
    
}
