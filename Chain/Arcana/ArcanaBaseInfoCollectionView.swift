//
//  ArcanaBaseInfoCollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 6/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaBaseInfoCollectionView: BaseTableViewCell {

    var arcana: Arcana?
    weak var arcanaDetailDelegate: ArcanaDetail?
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .groupTableViewBackground
        collectionView.alpha = 0
        collectionView.fadeIn()
        
        collectionView.register(ArcanaNameCell.self, forCellWithReuseIdentifier: "ArcanaNameCell")
        collectionView.register(ArcanaBaseInfoCell.self, forCellWithReuseIdentifier: "ArcanaBaseInfoCell")
        collectionView.register(ArcanaClassBaseInfoCell.self, forCellWithReuseIdentifier: "ArcanaClassBaseInfoCell")
        collectionView.register(ArcanaButtonsCell.self, forCellWithReuseIdentifier: "ArcanaButtonsCell")
        
        return collectionView
    }()
    
    override func setupViews() {
        
        addSubview(collectionView)
        
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func getRarityLong(_ string: String) -> String {
        
        switch string {
            
        case "5★", "5":
            return "SSR ★ 5"
        case "4★", "4":
            return "SR ★ 4"
        case "3★", "3":
            return "R ★ 3"
        case "2★", "2":
            return "HN ★ 2"
        case "1★", "1":
            return "N ★ 1"
        default:
            return "업데이트 필요"
        }
        
    }

}

extension ArcanaBaseInfoCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Section: Int {
        case name
        case baseInfo
        case likes
    }
    
    private enum Row: Int {
        case rarity
        case cost
        case group
        case weapon
        case affiliation
        case tavern
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .name:
            return 1
        case .baseInfo:
            return 6
        case .likes:
            return 1
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Section(rawValue: indexPath.section), let arcana = arcana else { return collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaClassBaseInfoCell", for: indexPath) as! ArcanaClassBaseInfoCell }
        
        switch section {
            
        case .name:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaNameCell", for: indexPath) as! ArcanaNameCell
            
            cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .profile, completion: { arcanaImage in
                
                DispatchQueue.main.async {
                    if let imageCell = collectionView.cellForItem(at: indexPath) as? ArcanaNameCell {
                        imageCell.arcanaImageView.animateImage(arcanaImage)
                    }
                }
            })
            
            if let nnKR = arcana.getNicknameKR() {
                cell.arcanaNameKR.text = nnKR + " " + arcana.getNameKR()
            }
            else {
                cell.arcanaNameKR.text = arcana.getNameKR()
            }
            
            if let nnJP = arcana.getNicknameJP() {
                cell.arcanaNameJP.text = nnJP + arcana.getNameJP()
            }
            else {
                cell.arcanaNameJP.text = arcana.getNameJP()
            }
            
            return cell

        case .baseInfo:
            guard let row = Row(rawValue: indexPath.row) else { return collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaClassBaseInfoCell", for: indexPath) as! ArcanaClassBaseInfoCell }

            var attributeKey = ""
            var attributeValue = ""
            
            switch row {
                
            case .group:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaClassBaseInfoCell", for: indexPath) as! ArcanaClassBaseInfoCell
                
                cell.attributeKeyLabel.text = "직업"
                cell.attributeValueLabel.text = arcana.getGroup()
                
                switch arcana.getGroup() {
                case "전사":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "warrior")
                case "기사":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "knight")
                case "궁수":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "archer")
                case "법사":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "magician")
                case "승려":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "healer")
                default:
                    break
                }
                
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaBaseInfoCell", for: indexPath) as! ArcanaBaseInfoCell
                
                guard let row = Row(rawValue: indexPath.row) else { return cell }
                
                switch row {
                    
                case .rarity:
                    attributeKey = "레어"
                    attributeValue = getRarityLong(arcana.getRarity())
                case .cost:
                    attributeKey = "코스트"
                    attributeValue = arcana.getCost()
                case .weapon:
                    attributeKey = "무기"
                    attributeValue = arcana.getWeapon()
                case .affiliation:
                    attributeKey = "소속"
                    if let a = arcana.getAffiliation() {
                        if a == "" {
                            attributeValue = "정보 없음"
                        }
                        else {
                            attributeValue = a
                        }
                    }
                    else {
                        attributeValue = "정보 없음"
                    }
                    
                case .tavern:
                    attributeKey = "출현 장소"
                    attributeValue = arcana.getTavern()
                    
                default:
                    break
                    
                }
                
                cell.attributeKeyLabel.text = attributeKey
                cell.attributeValueLabel.text = attributeValue
                
                return cell
                
            }

        case .likes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaButtonsCell", for: indexPath) as! ArcanaButtonsCell

            cell.arcanaDetailDelegate = arcanaDetailDelegate
            cell.numberOfLikesLabel.text = "\(arcana.getNumberOfLikes())"
            
            let userLikes = defaults.getLikes()
            if !userLikes.contains(arcana.getUID()) {
                cell.heartButton.isSelected = false
            }
            else {
                cell.heartButton.isSelected = true
            }
            
            let userFavorites = defaults.getFavorites()
            if !userFavorites.contains(arcana.getUID()) {
                cell.favoriteButton.isSelected = false
            }
            else {
                cell.favoriteButton.isSelected = true
            }
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let section = Section(rawValue: indexPath.section) else { return CGSize() }
        
        switch section {
        case .name:
            return CGSize(width: collectionView.frame.width, height: 90)
        case .baseInfo:
            return CGSize(width: (collectionView.frame.width - 1) / 2, height: 80)
        case .likes:
            return CGSize(width: collectionView.frame.width, height: 50)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let section = Section(rawValue: section) else { return UIEdgeInsets.zero }
        switch section {
        case .name, .baseInfo:
            return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        default:
            return UIEdgeInsets.zero
        }
        
    }
}
