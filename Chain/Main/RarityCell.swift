//
//  RarityCell.swift
//  Chain
//
//  Created by Jitae Kim on 9/7/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RarityCell: UICollectionViewCell {
    
//    @IBOutlet weak var rarity: UILabel!
//    @IBOutlet weak var rarityIcon: UIImageView!
    
    let rarityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        label.textColor = Color.textGray
        label.highlightedTextColor = .white
        return label
    }()
    
    let rarityIcon: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "starGray"))
        imageView.contentMode = .scaleToFill
        imageView.highlightedImage = #imageLiteral(resourceName: "starWhite")
        return imageView
    }()
    
    func setupViews() {
        
        backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.lightGreen
        selectedBackgroundView = backgroundView

        let stackView = UIStackView(arrangedSubviews: [rarityIcon, rarityLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        
        addSubview(stackView)
        
        stackView.anchorCenterSuperview()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        rarity.highlightedTextColor = UIColor.white
//        rarityIcon.highlightedImage = UIImage(named: "starWhite.png")
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = Color.lightGreen
//        self.selectedBackgroundView = backgroundView
//    }
//
    
//    override var highlighted: Bool {
//        get {
//            return super.highlighted
//        }
//        set {
//            if newValue {
//                self.contentView.backgroundColor = Color.lightGreen
//                rarity.textColor = UIColor.whiteColor()
//                rarityIcon.image = UIImage(named: "starWhite.png")
//            }
//            else {
//                self.contentView.backgroundColor = UIColor.whiteColor()
//                rarity.textColor = Color.lightGreen
//                rarityIcon.image = UIImage(named: "starGray.png")
//            }
//            super.highlighted = newValue
//        }
//    }
    
}
