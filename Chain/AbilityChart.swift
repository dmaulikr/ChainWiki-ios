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
    var collectionView: UICollectionView!
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var knights: UICollectionView!
    @IBOutlet weak var archers: UICollectionView!

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCell
            cell.tableTitle.text = "메인 어빌리티"
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as! LabelCell
            cell.tableTitle.text = "캐릭터 이름"
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "arcanaProfileCell", for: indexPath) as! ArcanaProfileCell
            cell.arcanaNameKR.text = "이름"
            cell.arcanaImage.image = #imageLiteral(resourceName: "emailSalmon")
            return cell
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 70, height: 70)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 2000, height: 1000), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
        collectionView.register(UINib(nibName: "ArcanaProfileCell", bundle: nil), forCellWithReuseIdentifier: "arcanaProfileCell")
        collectionView.backgroundColor = UIColor.white 
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        contentView.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.contentSize = contentView.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        contentView.addSubview(collectionView)
        
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
        return CGSize(width: 70, height: 70)
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        
//        switch section {
//        case 0: // This one needs higher top inset
//            return UIEdgeInsetsMake(14, 14, 7, 14)
//        default:
//            return UIEdgeInsetsMake(7, 14, 7, 14)
//        }
//        
//        
//        
//    }
//    
//    
    
    
}
