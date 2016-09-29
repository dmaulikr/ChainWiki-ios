//
//  AbilityChart.swift
//  Chain
//
//  Created by Jitae Kim on 9/26/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityChart: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var scrollView: UIScrollView!
    var contentView: UIView!
    var warriorView: UICollectionView!
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var knights: UICollectionView!
    @IBOutlet weak var archers: UICollectionView!

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 2
            
        case 1:
            return 4
            
        default:
            return 6
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
            
        case 0:
            
            let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCell
    
            switch indexPath.row {
            
            case 0:
                labelCell.tableTitle.text = "기사"
                
            default:
                labelCell.tableTitle.text = "인연 어빌리티"

            }
            return labelCell
            
        case 1:
            
            let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCell
            
            switch indexPath.row {
            case 0:
                break
            case 1:
                labelCell.tableTitle.text = "10%"
            case 2:
                labelCell.tableTitle.text = "15%"
            default:
                labelCell.tableTitle.text = "20%"
            }
            
            return labelCell
            
        case 2:
            
            switch indexPath.row {
            case 0:
                let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCell
                labelCell.tableTitle.text = "메인\n어빌리티"
                return labelCell
            case 1:
                let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCell
                labelCell.tableTitle.text = "아르카나"
                return labelCell
            case 2:
                let arcanaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "arcanaProfileCell", for: indexPath) as! ArcanaProfileCell
                arcanaCell.arcanaNameKR.text = "멜리사"
                return arcanaCell
            case 3:
                let arcanaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "arcanaProfileCell", for: indexPath) as! ArcanaProfileCell
                arcanaCell.arcanaNameKR.text = "드림캐스트"
                return arcanaCell
            case 4:
                let arcanaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "arcanaProfileCell", for: indexPath) as! ArcanaProfileCell
                arcanaCell.arcanaNameKR.text = "무스타파"
                return arcanaCell
            default:
                let arcanaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "arcanaProfileCell", for: indexPath) as! ArcanaProfileCell
                arcanaCell.arcanaNameKR.text = "멜리오다스"
                return arcanaCell
            }
            
        default:
                let arcanaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "arcanaProfileCell", for: indexPath) as! ArcanaProfileCell
                arcanaCell.arcanaNameKR.text = "이름"
                arcanaCell.arcanaImage.image = #imageLiteral(resourceName: "iris")
                arcanaCell.layer.borderWidth = 0
                return arcanaCell

        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 70, height: 70)
//        layout.minimumInteritemSpacing = 0
        
        warriorView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 425, height: 1000), collectionViewLayout: layout)
        warriorView.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
        warriorView.register(UINib(nibName: "ArcanaProfileCell", bundle: nil), forCellWithReuseIdentifier: "arcanaProfileCell")
        warriorView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        warriorView.delegate = self
        warriorView.dataSource = self
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        contentView.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.contentSize = contentView.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        contentView.addSubview(warriorView)
        
        /*
        scrollView.delegate = self
        scrollView.contentSize.width = 2000
        scrollView.contentSize.height = 2000
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
//        knights.delegate = self
//        knights.dataSource = self
//        archers.delegate = self
//        archers.dataSource = self
        collectionView.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
        collectionView.register(UINib(nibName: "ArcanaProfileCell", bundle: nil), forCellWithReuseIdentifier: "arcanaProfileCell")
        
//        knights.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
//        knights.register(UINib(nibName: "ArcanaProfileCell", bundle: nil), forCellWithReuseIdentifier: "arcanaProfileCell")
//        
//        archers.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
//        archers.register(UINib(nibName: "ArcanaProfileCell", bundle: nil), forCellWithReuseIdentifier: "arcanaProfileCell")
 
 */
 
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

extension AbilityChart : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelHeight = CGFloat(25)
        let arcanaHeight = CGFloat(80)
        // 425 width
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
            case 0:// 전사
                return CGSize(width: 141, height: labelHeight)
            default:    // 1
                return CGSize(width: 283, height: labelHeight)
            }
            
        case 1:
            switch indexPath.row {
            case 0:// % values
                return CGSize(width: 141, height: labelHeight)
            case 1:
                return CGSize(width: 141, height: labelHeight)
                
            default:    // 2
                return CGSize(width: 70.0, height: labelHeight)
            }
            
        default:    //6
            return CGSize(width: 70.0, height: arcanaHeight)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsetsMake(0, 0, 1, 0)

        
    }
    
    
    
    
}
