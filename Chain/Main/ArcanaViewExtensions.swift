//
//  ArcanaViewExtensions.swift
//  Chain
//
//  Created by Jitae Kim on 3/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import FirebaseAnalytics

fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

extension ArcanaViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case image
        case arcana
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arcanaView == .main {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        if indexPath.section < arcanaArray.count {
            
            let arcana = arcanaArray[indexPath.section]
            
            if arcanaView == .list || (arcanaView == .main && row == .arcana) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
                
                cell.arcanaNickKR.text = nil
                cell.arcanaNickJP.text = nil
                cell.arcanaImage.image = nil
                
                cell.arcanaID = arcana.getUID()

                cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .profile, sender: cell)
                
                // check if arcana has only name, or nickname.
                if let nnKR = arcana.getNicknameKR() {
                    cell.arcanaNickKR.text = nnKR
                }
                if let nnJP = arcana.getNicknameJP() {
                    cell.arcanaNickJP.text = nnJP
                }
                cell.arcanaNameKR.text = arcana.getNameKR()
                cell.arcanaNameJP.text = arcana.getNameJP()
                
                cell.arcanaRarity.text = "#\(arcana.getRarity())★"
                cell.arcanaGroup.text = "#\(arcana.getGroup())"
                cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
                
                if let a = arcana.getAffiliation() {
                    if a != "" {
                        cell.arcanaAffiliation.text = "#\(a)"
                    }
                    
                }
                
                cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
                
                return cell
                
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaMainImageCell") as! ArcanaMainImageCell
                cell.arcanaImageView.image = nil
                
                cell.arcanaID = arcana.getUID()
                cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, sender: cell)
                
                return cell
            }

        }
        else {
            Analytics.logEvent("arcanaArrayCrashTV", parameters: [
                "indexPath" : indexPath.row,
                "arcanaArrayCount" : arcanaArray.count,
                "arcanaView" : arcanaView.rawValue
                ])
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
            return cell
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        selectedIndexPath = indexPath
        
        view.endEditing(true)
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.section]
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ArcanaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < arcanaArray.count {
            
            let arcana = arcanaArray[indexPath.row]
            
            switch arcanaView {
            case .list, .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainListTableView", for: indexPath) as! MainListTableView
                cell.collectionViewDelegate = self
                cell.arcana = arcana
                cell.arcanaView = arcanaView
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconCell", for: indexPath) as! ArcanaIconCell
                cell.arcanaImage.image = nil
                
                cell.arcanaID = arcana.getUID()
                
                switch arcanaView {
                    
                case .mainGrid:
                    cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .main, sender: cell)
                default:
                    cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .profile, sender: cell)
                    
                }
                return cell
                
            }

        }
        else {
            Analytics.logEvent("arcanaArrayCrashCV", parameters: [
                "indexPath" : indexPath.row,
                "arcanaArrayCount" : arcanaArray.count,
                "arcanaView" : arcanaView.rawValue
                ])
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconCell", for: indexPath) as! ArcanaIconCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.item]
        
        view.endEditing(true)
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch arcanaView {
            
        case .list:
            let cellSize: CGFloat
            
            if !ISIPADPRO {
                cellSize = ((collectionView.frame.width - 5)/2)
            }
            else {
                cellSize = (collectionView.frame.width - (sectionInsets.left * 2 + 5))/2
            }
            
            return CGSize(width: cellSize, height: 90)

        case .main:
            let cellSize: CGFloat
            
//            if !ISIPADPRO {
//                cellSize = ((collectionView.frame.width - 10)/2)
//            }
//            else {
                cellSize = (collectionView.frame.width - (sectionInsets.left * 2 + 5))/2
//            }
            
            return CGSize(width: cellSize, height: cellSize * 1.5 + 90)
            
        case .profile:
            let cellSize: CGFloat
            
            cellSize = (collectionView.frame.width - (sectionInsets.left * 2 + (5 * (numberOfProfileImageColumns-1))))/numberOfProfileImageColumns
            
            return CGSize(width: cellSize, height: cellSize)

        case .mainGrid:
            let cellSize: CGFloat
            
            cellSize = (collectionView.frame.width - (sectionInsets.left * 2 + 5))/2
            
            return CGSize(width: cellSize, height: cellSize * 1.5)

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if horizontalSize == .regular && !ISIPADPRO && arcanaView == .list {
            return .zero
        }
        
        return sectionInsets
    }
    
}
