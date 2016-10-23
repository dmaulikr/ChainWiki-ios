//
//  TavernView.swift
//  Chain
//
//  Created by Jitae Kim on 9/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol TavernViewDelegate : class {
    func didUpdate(_ sender: TavernView, tavern: String)
}

class TavernView: UIViewController {

    weak var delegate: TavernViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    let taverns = ["부도시", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "화염구령", "해풍의항구", "새벽대해", "수인의대륙", "죄의대륙", "박명의대륙", "철연의대륙", "연대기대륙", "서가", "레무레스섬"]
    let yugudo = ["부도시", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "화염구령", "해풍의항구"]
    let gyosae = ["새벽대해", "수인의대륙", "죄의대륙", "박명의대륙"]
    let giwon = ["철연의대륙", "연대기대륙", "서가"]
    let juhpyun = ["레무레스섬"]
    
    let continents = ["유그도대륙", "교쇄의해역", "기원의해역", "저편의해역"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        
        self.title = "주점"
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: animated)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toTavern") {

            var tavernRef = ""
            let cell = sender as! TavernCell
            let indexPath = collectionView.indexPath(for: cell)!
            
                switch indexPath.section {
                    
                case 0:
                    tavernRef = yugudo[indexPath.row]
                    
                case 1:
                    tavernRef = gyosae[indexPath.row]
                    
                case 2:
                    tavernRef = giwon[indexPath.row]
                    
                default:
                    tavernRef = juhpyun[indexPath.row]
                    
                    
                }
            
            
            let vc = segue.destination as! TavernHomeView
            vc.navTitle = tavernRef
            vc.tavern = convertTavern(tavern: tavernRef)
        }
        
    }


}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TavernView: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            
            headerView.sectionTitle.text = continents[indexPath.section]
            return headerView
        }
        
        return UICollectionReusableView()
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "toTavern", sender: cell)
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TavernView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // inset = sectionInset(28)+cellspacing
        let inset = CGFloat(31)
//        let cellSpace = CGFloat(1)
//        let separatorCount = CGFloat(3)
        
        switch (indexPath as NSIndexPath).section {
        case 0,1,2:
            return CGSize(width: (SCREENWIDTH-inset)/4, height: 40)
            
        default:
            return CGSize(width: (SCREENWIDTH-inset)/4, height: 40)
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


