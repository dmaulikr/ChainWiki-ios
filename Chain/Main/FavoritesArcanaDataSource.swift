//
//  FavoritesDataSource.swift
//  Chain
//
//  Created by Jitae Kim on 3/16/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class FavoritesArcanaDataSource: ArcanaDataSource {
        
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = arcanaArray[sourceIndexPath.row]
        arcanaArray.remove(at: sourceIndexPath.row)
        arcanaArray.insert(itemToMove, at: destinationIndexPath.row)
        
    }

}
