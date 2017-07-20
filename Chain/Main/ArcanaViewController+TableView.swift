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
                
                cell.setupCell(arcana: arcana)
                
                cell.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.iconURL, completion: { (arcanaID, arcanaImage) in
                    
                    if arcanaID == cell.arcanaID {
                        DispatchQueue.main.async {
                            cell.arcanaImageView.animateImage(arcanaImage)
                        }
                    }
                    
                })
                
                return cell
                
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaMainImageCell") as! ArcanaMainImageCell
                
                cell.arcanaID = arcana.getUID()
                
                cell.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.imageURL, completion: { (arcanaID, arcanaImage) in
                    
                    if arcanaID == cell.arcanaID {
                        DispatchQueue.main.async {
                            cell.arcanaImageView.animateImage(arcanaImage)
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
        
        let arcanaDetailVC = ArcanaDetail(arcana: arcana)
//        navigationController?.pushViewController(arcanaDetailVC, animated: true)
        arcanaDetailVC.navigationItem.leftItemsSupplementBackButton = true
        arcanaDetailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        splitViewController?.showDetailViewController(NavigationController(arcanaDetailVC), sender: nil)
        
    }
    
}
