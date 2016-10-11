//
//  ArcanaImageCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage

class ArcanaImageCell: UITableViewCell {

    @IBOutlet weak var arcanaImage: UIImageView!
    @IBOutlet weak var imageSpinner: NVActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
