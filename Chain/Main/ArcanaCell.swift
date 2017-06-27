//
//  Homeswift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ArcanaCell: ArcanaImageIDCell {

    @IBOutlet weak var arcanaImageView: UIImageView!
    @IBOutlet weak var arcanaNameKR: UILabel!
    @IBOutlet weak var arcanaNickKR: UILabel!
    @IBOutlet weak var arcanaNameJP: UILabel!
    @IBOutlet weak var arcanaNickJP: UILabel!
    @IBOutlet weak var arcanaRarity: UILabel!
    @IBOutlet weak var arcanaWeapon: UILabel!
    @IBOutlet weak var arcanaGroup: UILabel!
    @IBOutlet weak var arcanaAffiliation: UILabel!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var imageSpinner: NVActivityIndicatorView!
        
    @IBOutlet var labelCollection: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for label in labelCollection {
            label.text = nil
        }
    }
    
    func setupCell(arcana: Arcana) {
        
        arcanaID = arcana.getUID()
        
        if let nnKR = arcana.getNicknameKR() {
            arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.getNicknameJP() {
            arcanaNickJP.text = nnJP
        }
        arcanaNameKR.text = arcana.getNameKR()
        arcanaNameJP.text = arcana.getNameJP()
        
        arcanaRarity.text = "#\(arcana.getRarity())★"
        arcanaGroup.text = "#\(arcana.getGroup())"
        arcanaWeapon.text = "#\(arcana.getWeapon())"
        
        if let a = arcana.getAffiliation() {
            if a != "" {
                arcanaAffiliation.text = "#\(a)"
            }
        }
        
        numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
    }

}

