//
//  HomeViewController+TableView.swift
//  Chain
//
//  Created by Jitae Kim on 7/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //TODO: Check if there is a festival
        guard let section = ArcanaSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .reward:
            if rewardArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        case .festival:
            if festivalArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        case .new:
            if newArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        case .legend:
            if legendArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        }
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let section = ArcanaSection(rawValue: section) else { return 0 }
        
        switch section {
        case .reward:
            if rewardArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        case .festival:
            if festivalArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        case .new:
            if newArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        case .legend:
            if legendArcanaArray.count == 0 {
                return CGFloat.leastNormalMagnitude
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewHeaderCell") as! HomeTableViewHeaderCell
        
        guard let section = ArcanaSection(rawValue: section) else { return nil }
        
        switch section {
        case .reward:
            if rewardArcanaArray.count == 0 {
                return nil
            }
            else {
                cell.sectionTitleLabel.text = "보상 아르카나"
            }
        case .festival:
            if festivalArcanaArray.count == 0 {
                return nil
            }
            else {
                cell.sectionTitleLabel.text = "페스티벌 아르카나"
            }
        case .new:
            if newArcanaArray.count == 0 {
                return nil
            }
            else {
                cell.sectionTitleLabel.text = "새로운 아르카나"
            }
        case .legend:
            if legendArcanaArray.count == 0 {
                return nil
            }
            else {
                cell.sectionTitleLabel.text = "레전드 아르카나"
            }
        }
        
        cell.homeDelegate = self
        cell.arcanaSection = section
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell") as! HomeViewTableViewCell
        
        guard let section = ArcanaSection(rawValue: indexPath.section) else { return cell }
        
        cell.setupCollectionView(self, arcanaSection: section)
        cell.collectionView.reloadData()
//        switch section {
//        case .festival:
//            cell.setupCollectionView(self, arcanaSection: .festival)
//        case .new:
//            cell.setupCollectionView(self, arcanaSection: .new)
//        }
        return cell
    }
    
}

