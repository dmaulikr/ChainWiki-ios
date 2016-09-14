//
//  MyCollectionViewLayout.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class MyCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        print("OWEFO")
        if (indexPath as NSIndexPath).section == 1 {
            print("HOWEFHOEW")
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            // or whatever...
            return layoutAttributes
            
        }
        if (indexPath as NSIndexPath).section == 2 {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            // or whatever...
            return layoutAttributes
        }
        else {
            return super.layoutAttributesForItem(at: indexPath)
        }
    }
    


}
