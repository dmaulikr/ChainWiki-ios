//
//  ArcanaViewEditsCell.swift
//  Chain
//
//  Created by Jitae Kim on 10/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaViewEditsCell: UITableViewCell {

    let editLabel: UILabel = {
        let label = UILabel()
        label.text = "편집 기록"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        return label
    }()
    
    let arrow: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "go")
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(editLabel)
        addSubview(arrow)
        
        editLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        arrow.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
    }


}
