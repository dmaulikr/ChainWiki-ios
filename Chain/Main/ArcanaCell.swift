//
//  HomeCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ArcanaCell: ArcanaImageIDCell {


    @IBOutlet weak var arcanaImage: UIImageView!
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for label in labelCollection {
            label.text = nil
        }
    }

}
