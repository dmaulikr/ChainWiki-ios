//
//  ArcanaViewController+Drag.swift
//  Chain
//
//  Created by Jitae Kim on 6/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
extension ArcanaViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let sectionSize = tableView.rect(forSection: indexPath.section).size
        UIGraphicsBeginImageContextWithOptions(sectionSize, false, 0)
        
        for row in 0 ..< tableView.numberOfRows(inSection: indexPath.section)  {
            
            let indexPath = IndexPath(row: row, section: indexPath.section)
            guard let context = UIGraphicsGetCurrentContext(), let cell = tableView.cellForRow(at: indexPath) else { return [] }
            cell.layer.render(in: context)
            tableView.scrollToRow(at: indexPath, at: .none, animated: false)
            
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            let provider = NSItemProvider(object: image)
            return [
                UIDragItem(itemProvider: provider)
            ]
        }
        
        return []
    }
    
}

@available(iOS 11.0, *)
extension ArcanaViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return [] }
        
        let cellSize = cell.frame.size
        UIGraphicsBeginImageContextWithOptions(cellSize, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return [] }
        cell.layer.render(in: context)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            let provider = NSItemProvider(object: image)
            return [
                UIDragItem(itemProvider: provider)
            ]
        }
        
        return []
    }
    
    
}
