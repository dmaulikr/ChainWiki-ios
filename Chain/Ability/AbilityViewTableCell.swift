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
    
    fileprivate var arcanaArray = [Arcana]()

    var currentArray = [Arcana]() {
        didSet {
            arcanaDataSource = ArcanaDataSource(currentArray)
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

        tableDelegate?.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

