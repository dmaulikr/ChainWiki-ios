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
        
        if let collectionView = collectionView as? ArcanaHorizontalCollectionView {
        
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
        else if let collectionView = collectionView as? ArcanaPreviewHorizontalCollectionView {
            return 5
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionView = collectionView as? ArcanaHorizontalCollectionView {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconCell", for: indexPath) as! ArcanaIconCell

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
    //        cell.heroID = arcana.getUID() + "\(collectionView.arcanaSection.rawValue)"
    //        cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleMain")
            cell.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.imageURL) { (arcanaID, arcanaImage) in
                if arcanaID == cell.arcanaID {
                    DispatchQueue.main.async {
                        cell.arcanaImageView.animateImage(arcanaImage)
                    }
                }
            }
            
            return cell
        }
        else if let collectionView = collectionView as? ArcanaPreviewHorizontalCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaPreviewViewWrapperCollectionViewCell", for: indexPath) as! ArcanaPreviewViewWrapperCollectionViewCell
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
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
