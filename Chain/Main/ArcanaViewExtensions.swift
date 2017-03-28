//
//  ArcanaViewExtensions.swift
//  Chain
//
//  Created by Jitae Kim on 3/26/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

extension ArcanaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if arcanaArray.count > 0 {
            return AbilitySectionHeader(sectionTitle: "아르카나 수 \(arcanaArray.count)")
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        cell.arcanaNickKR.text = nil
        cell.arcanaNickJP.text = nil
        cell.arcanaImage.image = nil
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.row]
        
        cell.arcanaID = arcana.getUID()
        cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .icon, sender: cell)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        selectedIndexPath = indexPath
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.row]
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ArcanaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Row: Int {
        case icon
        case iconLabel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch arcanaView {
        case .icon:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconCell", for: indexPath) as! ArcanaIconCell
            cell.arcanaImage.image = nil
            
            let arcana: Arcana
            arcana = arcanaArray[indexPath.row]
            cell.arcanaID = arcana.getUID()
            
            cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .icon, sender: cell)
            return cell

        case .iconLabel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconLabelCell", for: indexPath) as! ArcanaIconLabelCell
            cell.arcanaImage.image = nil
            
            let arcana: Arcana
            arcana = arcanaArray[indexPath.row]
            cell.arcanaID = arcana.getUID()
            
            cell.nameLabel.text = arcana.getNameKR()
            cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .icon, sender: cell)
            return cell

        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.item]
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize: CGFloat
        
        cellSize = (collectionView.frame.width - (sectionInsets.left * 2 + 15))/4

        if arcanaView == .iconLabel {
            return CGSize(width: cellSize, height: cellSize + 20)
        }


        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}
