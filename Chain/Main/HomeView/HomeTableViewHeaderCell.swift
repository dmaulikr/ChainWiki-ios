//
//  HomeTableViewHeaderCell.swift
//  Chain
//
//  Created by Jitae Kim on 7/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class HomeTableViewHeaderCell: UITableViewHeaderFooterView {
    
    weak var homeDelegate: HomeViewProtocol?
    
    var arcanaSection: ArcanaSection!
    
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        return label
    }()
    
    lazy var viewMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        button.addTarget(self, action: #selector(viewMore), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(sectionTitleLabel)
        addSubview(viewMoreButton)
        
        sectionTitleLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        sectionTitleLabel.anchorCenterYToSuperview()
        
        viewMoreButton.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc
    func viewMore() {
        
        guard let arcanaSection = arcanaSection else { return }
        homeDelegate?.viewMore(arcanaSection: arcanaSection)
        
    }
}

