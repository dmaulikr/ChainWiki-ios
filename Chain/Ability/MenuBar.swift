//
//  MenuBar.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

enum menuType {
    case abilityList
    case abilityView
    case tavernList
}

class MenuBar: UIView {

    let menuHeight : CGFloat = 40
    let sectionTitles = ["메인", "인연"]
    let classTypes = ["전사", "기사", "궁수", "법사", "승려"]
    let tavernTypes = ["1부", "2부", "3부"]
    weak var parentController: CollectionViewWithMenu?
    var numberOfItems: Int = 2
    var menuType: menuType?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 40), collectionViewLayout: layout)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "menuCell")
        let firstItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstItem, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfItems = 2
        
//        setupMenuBar()
        setupBottomBorder()
        setupHorizontalBar()
        
        
    }
    
    
    init(frame: CGRect, menuType: menuType) {
        super.init(frame: frame)
        self.menuType = menuType
        switch menuType {
            case .abilityList:
                numberOfItems = 2
            case .abilityView:
                numberOfItems = 5
            case .tavernList:
                numberOfItems = 3
        }
        
        addSubview(collectionView)
        setupBottomBorder()
        setupHorizontalBar()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupMenuBar() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupBottomBorder() {
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = Color.lightGray
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorderView)
        bottomBorderView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomBorderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.lightGreen
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(1)/CGFloat(numberOfItems), constant: -20).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true

    }
    
    func setupSectionSeparator() {
        let line = UIView()
        line.backgroundColor = Color.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        line.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
}


extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.backgroundColor = .white
        if indexPath.row != 0 {
            cell.nameLabel.textColor = Color.textGray
        }
        
        if let menuType = menuType {
            
            switch menuType {
            case .abilityList:
                cell.nameLabel.text = sectionTitles[indexPath.row]
            case .abilityView:
                cell.nameLabel.text = classTypes[indexPath.row]
            case .tavernList:
                cell.nameLabel.text = tavernTypes[indexPath.row]
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        parentController?.scrollToMenuIndex(indexPath.item)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / CGFloat(numberOfItems), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

class MenuCell: UICollectionViewCell {
    
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                nameLabel.textColor = .black
            }
            else {
                nameLabel.textColor = Color.textGray
            }
        }
    }
    func setupViews() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
