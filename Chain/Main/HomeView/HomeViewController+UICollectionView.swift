//
//  HomeViewTableViewCell+UICollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 7/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let collectionView = collectionView as? ArcanaHorizontalCollectionView else { return 0 }
        
        switch collectionView.arcanaSection {
        case .reward:
            return rewardArcanaArray.count
        case .festival:
            return festivalArcanaArray.count
        case .new:
            return newArcanaArray.count
        case .legend:
            return legendArcanaArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconCell", for: indexPath) as! ArcanaIconCell
        
        guard let collectionView = collectionView as? ArcanaHorizontalCollectionView else { return cell }
        
        let arcana: Arcana
        
        switch collectionView.arcanaSection {
        case .reward:
            arcana = rewardArcanaArray[indexPath.item]
        case .festival:
            arcana = festivalArcanaArray[indexPath.item]
        case .new:
            arcana = newArcanaArray[indexPath.item]
        case .legend:
            arcana = legendArcanaArray[indexPath.item]
        }
        
        cell.arcanaID = arcana.getUID()
        cell.heroID = arcana.getUID() + "\(collectionView.arcanaSection.rawValue)"
        print(cell.heroID)
        cell.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.imageURL) { (arcanaID, arcanaImage) in
            if arcanaID == cell.arcanaID {
                DispatchQueue.main.async {
                    cell.arcanaImageView.animateImage(arcanaImage)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let collectionView = collectionView as? ArcanaHorizontalCollectionView else { return }
        
        for indexPath in indexPaths {
            
            let arcana: Arcana
            
            switch collectionView.arcanaSection {
            case .reward:
                arcana = rewardArcanaArray[indexPath.item]
            case .festival:
                arcana = festivalArcanaArray[indexPath.item]
            case .new:
                arcana = newArcanaArray[indexPath.item]
            case .legend:
                arcana = legendArcanaArray[indexPath.item]
            }
            
            ImageHelper.shared.prefetchImages(arcanaID: arcana.getUID(), urlString: arcana.imageURL)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let collectionView = collectionView as? ArcanaHorizontalCollectionView,
            let cell = collectionView.cellForItem(at: indexPath) as? ArcanaIconCell else { return }
        
        let section = collectionView.arcanaSection
        print("selected \(cell.heroID!)")
        pushView(arcanaSection: section, index: indexPath.item)
    }
    
    // Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 290, height: 400)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
}
