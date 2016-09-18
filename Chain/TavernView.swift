//
//  TavernView.swift
//  Chain
//
//  Created by Jitae Kim on 9/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TavernView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let taverns = ["부도시", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "구령", "바닷항구", "대해", "수인", "죄의대륙", "박명의대륙", "철연의대륙", "연대기", "서가", "레무레스"]
    
    let yugudo = ["부도시", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "구령", "바닷항구"]
    let gyosae = ["대해", "수인", "죄의대륙", "박명의대륙"]
    let giwon = ["철연의대륙", "연대기", "서가"]
    let juhpyun = ["레무레스"]
    
    let continents = ["유그도대륙", "교쇄의해역", "기원의해역", "저편의해역"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 8
        case 1:
            return 4
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TavernHeader
            

            switch indexPath.section {
            case 0:
                headerView.sectionTitle.text = "유그도대륙"
            case 1:
                headerView.sectionTitle.text = "교쇄의해역"
            case 2:
                headerView.sectionTitle.text = "기원의해역"
            default:
                headerView.sectionTitle.text = "저편의해역"
                
                
            }
            return headerView
        }
        
        assert(false, "unexpected element kind")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tavern", for: indexPath) as! TavernCell
        
        
        switch indexPath.section {
        case 0:
            cell.tavernName.text = yugudo[indexPath.row]
        case 1:
            cell.tavernName.text = gyosae[indexPath.row]
        case 2:
            cell.tavernName.text = giwon[indexPath.row]
        default:
            cell.tavernName.text = juhpyun[indexPath.row]
            
        }
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = darkNavyColor.cgColor
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        return cell
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TavernView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = CGFloat(37)
//        let cellSpace = CGFloat(1)
//        let separatorCount = CGFloat(3)
        
        switch (indexPath as NSIndexPath).section {
        case 0,1,2:
            return CGSize(width: (SCREENWIDTH-inset)/4, height: 60)
            
        default:
            return CGSize(width: (SCREENWIDTH-inset)/4, height: 60)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
//        switch section {
//        case 0: // This one needs higher top inset
//            return UIEdgeInsetsMake(14, 14, 7, 14)
//        default:
            return UIEdgeInsetsMake(7, 14, 7, 14)
//        }
        
        
        
    }
    
    
    
    
}


