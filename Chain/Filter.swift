//
//  Filter.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class Filter: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let rarity = ["5★", "4★", "3★", "2★", "1★"]
    let group = ["전사", "기사","궁수","법사","승려"]
    let weapon = ["검", "봉", "창", "마", "궁", "성", "권", "총", "저"]
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: // Rarity
            return 5
        case 1: // Class
            return 5
        case 2: // Weapon
            return 9
        default:    // Affiliation?
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0: // Rarity
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rarity", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = rarity[indexPath.row]
            
            return cell
            
        default:    // Class
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rarity", forIndexPath: indexPath) as! FilterCell
            cell.filterType.text = group[indexPath.row]
            return cell
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
