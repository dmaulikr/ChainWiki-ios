//
//  MyCollectionViewLayout.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class MyCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        print("OWEFO")
        if indexPath.section == 1 {
            print("HOWEFHOEW")
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            layoutAttributes.frame = CGRectMake(0, 0, 100, 100)
            // or whatever...
            return layoutAttributes
            
        }
        if indexPath.section == 2 {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            layoutAttributes.frame = CGRectMake(0, 0, 100, 100)
            // or whatever...
            return layoutAttributes
        }
        else {
            return super.layoutAttributesForItemAtIndexPath(indexPath)
        }
    }
    


}
