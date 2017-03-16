//
//  MenuBar.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

enum MenuType {
    case abilityList
    case abilityView
    case tavernList
}

class MenuBar: UIView {

    weak var menuBarDelegate: MenuBarViewController?

    let menuType: MenuType
    let menuHeight : CGFloat = 40
    let numberOfItems: Int

    let abilityTypes = ["메인", "인연"]
    let classTypes = ["전사", "기사", "궁수", "법사", "승려"]
    let tavernTypes = ["1부", "2부", "3부"]
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 40), collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false

        collectionView.backgroundColor = .white

        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        
        let firstItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstItem, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        return collectionView
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        return view
    }()
    
    var horizontalBarLeadingAnchorConstraint: NSLayoutConstraint?

    let horizontalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightGreen
        return view
    }()
    
    init(menuType: MenuType) {
        
        self.menuType = menuType

        switch menuType {
        case .abilityList:
            numberOfItems = 2
        case .abilityView:
            numberOfItems = 5
        case .tavernList:
            numberOfItems = 3
        }
        
        super.init(frame: .zero)

        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(collectionView)
        addSubview(bottomBorderView)
        addSubview(horizontalBarView)
        
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: menuHeight)
        
        bottomBorderView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1)
        
        horizontalBarView.anchor(top: nil, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 2)
        
        horizontalBarLeadingAnchorConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        horizontalBarLeadingAnchorConstraint?.isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(1)/CGFloat(numberOfItems), constant: -20).isActive = true
        
    }

}


extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell

        switch menuType {
        case .abilityList:
            cell.nameLabel.text = abilityTypes[indexPath.row]
        case .abilityView:
            cell.nameLabel.text = classTypes[indexPath.row]
        case .tavernList:
            cell.nameLabel.text = tavernTypes[indexPath.row]
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuBarDelegate?.childViewController?.scrollToMenuIndex(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(numberOfItems), height: frame.height)
    }
    
}

class MenuCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textGray
        label.highlightedTextColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(nameLabel)
        
        nameLabel.anchorCenterSuperview()
    }
    
}
