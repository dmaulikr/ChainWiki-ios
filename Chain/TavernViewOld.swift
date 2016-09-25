//
//  TavernView.swift
//  
//
//  Created by Jitae Kim on 9/5/16.
//
//

import UIKit
//import Toucan

class TavernViewOld: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let taverns = ["부도시", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "구령", "해풍의항구", "대해", "수인", "죄의대륙", "박명의대륙", "철연의대륙", "연대기", "서가", "레무레스"]
    
    let images = [UIImage(named: "budo.jpg")!, UIImage(named: "sungdo.jpg")!, UIImage(named: "hyunja.jpg")!, UIImage(named: "migoong.jpg")!, UIImage(named: "hodo.jpg")!, UIImage(named: "jungryeong.jpg")!, UIImage(named: "guryeong.jpg")!, UIImage(named: "hangu.jpg")!, UIImage(named: "dahae.jpg")!, UIImage(named: "sooin.jpg")!, UIImage(named: "jwe.jpg")!, UIImage(named: "bakmyung.jpg")!, UIImage(named: "chulryeon.jpg")!, UIImage(named: "yeondaegi.jpg")!, UIImage(named: "seoga.jpg")!, UIImage(named: "remures.jpg")!]
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tavernCell", for: indexPath) as! TavernViewCell
        cell.tavernName.text = taverns[(indexPath as NSIndexPath).row]
        cell.tavernName.textColor = UIColor.white
        cell.backgroundColor = darkNavyColor
//        let crop = Toucan(image: images[indexPath.row]).resize(cell.tavernImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//        
//        cell.tavernImage.image = crop
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = darkNavyColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TavernView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch (indexPath as NSIndexPath).section {
        default:
            return CGSize(width: (SCREENWIDTH-70)/4, height: (SCREENWIDTH-20)/3)
            
        }
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}

