//
//  HomeViewTableViewCell+UICollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 7/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ArcanaIconCell else { return }
        
        guard let collectionView = collectionView as? ArcanaHorizontalCollectionView else { return }
        
        guard let arcana = arcanaAtArcanaSectionWithIndexPath(collectionView.arcanaSection, indexPath: indexPath) else { return }
        
        cell.placeholderImageView.alpha = 1
        cell.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.imageURL) { (arcanaID, arcanaImage) in

            DispatchQueue.main.async {
                guard let cell = collectionView.cellForItem(at: indexPath) as? ArcanaIconCell else { return }
                cell.placeholderImageView.alpha = 0
                cell.arcanaImageView.animateImage(arcanaImage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ArcanaIconCell else { return }
        
        cell.arcanaImageView.image = nil
        cell.placeholderImageView.alpha = 0
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let collectionView = collectionView as? ArcanaHorizontalCollectionView,
            let cell = collectionView.cellForItem(at: indexPath) as? ArcanaIconCell else { return }
        
        let section = collectionView.arcanaSection
        
        pushView(arcanaSection: section, indexPath: indexPath, cell: cell)
    }
    
    // Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 290, height: 450)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
}
