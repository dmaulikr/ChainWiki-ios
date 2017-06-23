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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if arcanaView == .main && indexPath.row == 0 {
            return tableView.frame.width * 1.5
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        if indexPath.section < arcanaArray.count {
            
            let arcana = arcanaArray[indexPath.section]
            
            if arcanaView == .list || (arcanaView == .main && row == .arcana) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
                
                cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .profile, completion: { arcanaImage in
                    
                    DispatchQueue.main.async {
                        if let imageCell = tableView.cellForRow(at: indexPath) as? ArcanaCell {
                            imageCell.arcanaImageView.animateImage(arcanaImage)
                        }
                    }
                })
                
                cell.setupCell(arcana: arcana)
                
                return cell
                
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaMainImageCell") as! ArcanaMainImageCell

                cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, completion: { arcanaImage in
                    
                    DispatchQueue.main.async {
                        if let imageCell = tableView.cellForRow(at: indexPath) as? ArcanaMainImageCell {
                            imageCell.arcanaImageView.animateImage(arcanaImage)
                        }
                    }
                })
                
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
        
        let arcana = arcanaArray[indexPath.section]
        
        if let detailViewController = delegate as? ArcanaDetail {
            detailViewController.arcanaSelected(arcana: arcana)
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
            
        else {
            // welcome screen
            let arcanaDetailVC = ArcanaDetail(arcana: arcana)
            arcanaDetailVC.navigationItem.leftItemsSupplementBackButton = true
            arcanaDetailVC.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
            
            self.delegate = arcanaDetailVC
            splitViewController?.showDetailViewController(NavigationController(arcanaDetailVC), sender: nil)
        }
        
//        let vc = ArcanaDetail(arcana: arcana)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ArcanaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let splitVC = splitViewController {
                        if splitVC.primaryColumnWidth <= 320 {
                            cell.numberOfColumns = 1
                        }
                        else {
                            cell.numberOfColumns = 2
                        }
                    }
                }
                cell.arcana = arcana
                cell.arcanaView = arcanaView
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaIconCell", for: indexPath) as! ArcanaIconCell                

                switch arcanaView {
                    
                case .mainGrid:
                    cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, completion: { arcanaImage in
                        
                        DispatchQueue.main.async {
                            if let imageCell = collectionView.cellForItem(at: indexPath) as? ArcanaIconCell {
                                imageCell.arcanaImageView.animateImage(arcanaImage)
                            }
                        }
                    })
                default:
                    cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .profile, completion: { arcanaImage in
                        
                        DispatchQueue.main.async {
                            if let imageCell = collectionView.cellForItem(at: indexPath) as? ArcanaIconCell {
                                imageCell.arcanaImageView.animateImage(arcanaImage)
                            }
                        }
                    })
                    
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
        
        view.endEditing(true)
        
        let arcana = arcanaArray[indexPath.item]
        

        if let detailViewController = delegate as? ArcanaDetail {
            detailViewController.arcanaSelected(arcana: arcana)
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
            
        else {
            // welcome screen
            let arcanaDetailVC = ArcanaDetail(arcana: arcana)
            arcanaDetailVC.navigationItem.leftItemsSupplementBackButton = true
            arcanaDetailVC.navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
            
            self.delegate = arcanaDetailVC
            splitViewController?.showDetailViewController(NavigationController(arcanaDetailVC), sender: nil)
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch arcanaView {
            
        case .list:
            let cellSize: CGFloat
            
//            if UIDevice.current.userInterfaceIdiom == .pad {
                if let splitVC = splitViewController {
                    if splitVC.primaryColumnWidth <= 320 {
                        cellSize = ((collectionView.frame.width - 5))
                    }
                    else {
                        cellSize = ((collectionView.frame.width - 5)/2)
                    }
                }
//            }
            else {
                cellSize = ((collectionView.frame.width - 5)/2)
            }
            
            return CGSize(width: cellSize, height: 90)

        case .main:
            let cellSize: CGFloat
            
            cellSize = (collectionView.frame.width - (sectionInsets.left * numberOfListColumns + 5))/numberOfListColumns
            
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
        if horizontalSize == .regular && arcanaView == .list {
            return .zero
        }
        
        return sectionInsets
    }
    
}
