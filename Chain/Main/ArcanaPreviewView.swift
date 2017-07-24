//
//  ArcanaPreviewView.swift
//  Chain
//
//  Created by Jitae Kim on 7/23/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPreviewView: GenericView {
    
    var arcanaID: String!
    
    @IBOutlet weak var arcanaImageView: UIImageView!
    @IBOutlet weak var arcanaNameKRLabel: UILabel!
    @IBOutlet weak var arcanaNickKRLabel: UILabel!
    @IBOutlet weak var arcanaNameJPLabel: UILabel!
    @IBOutlet weak var arcanaNickJPLabel: UILabel!
    @IBOutlet weak var arcanaRarityLabel: UILabel!
    @IBOutlet weak var arcanaClassLabel: UILabel!
    @IBOutlet weak var arcanaWeaponLabel: UILabel!
    @IBOutlet weak var arcanaAffiliationLabel: UILabel!
    @IBOutlet weak var numberOfViewsLabel: UILabel!
    
    func setupCell(arcana: Arcana) {
        
        arcanaID = arcana.getUID()
        
        if let nnKR = arcana.getNicknameKR() {
            arcanaNickKRLabel.text = nnKR
        }
        if let nnJP = arcana.getNicknameJP() {
            arcanaNickJPLabel.text = nnJP
        }
        arcanaNameKRLabel.text = arcana.getNameKR()
        arcanaNameJPLabel.text = arcana.getNameJP()
        
        arcanaRarityLabel.text = "#\(arcana.getRarity())★"
        arcanaClassLabel.text = "#\(arcana.getGroup())"
        arcanaWeaponLabel.text = "#\(arcana.getWeapon())"
        
        if let a = arcana.getAffiliation() {
            if a != "" {
                arcanaAffiliationLabel.text = "#\(a)"
            }
        }
        
        numberOfViewsLabel.text = "조회 \(arcana.getNumberOfViews())"
    }


}
