//
//  AbilityViewTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class AbilityViewTableCell: BaseCollectionViewCell {
    
    var currentArray = [Arcana]() {
        didSet {
            if currentArray.count > 0 {
                tipLabel.alpha = 0
                arcanaDataSource = ArcanaDataSource(currentArray)
                tableView.alpha = 1
            }
            else {
                tipLabel.alpha = 1
                tableView.alpha = 0
            }
        }
    }
    
    fileprivate var arcanaDataSource: ArcanaDataSource? {
        didSet {
            tableView.dataSource = arcanaDataSource
            tableView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        tableView.delegate = self
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
    }
    
}


extension AbilityViewTableCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        let arcana = currentArray[row]
        let vc = ArcanaDetail(arcana: arcana)

        collectionViewDelegate?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

