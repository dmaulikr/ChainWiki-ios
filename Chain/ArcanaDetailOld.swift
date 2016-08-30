////
////  ArcanaDetail.swift
////  Chain
////
////  Created by Jitae Kim on 8/27/16.
////  Copyright © 2016 Jitae Kim. All rights reserved.
////
//
//import UIKit
//import Kanna
//
//class ArcanaDetailOld: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    var arcanaID: Int?
//    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//    
//    var attributeValues = [String]()
//    let requiredAttributes = [1, 2, 4, 5, 8, 11, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40]
//    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        var header: MyCollectionViewHeader?
//        
//        if kind == UICollectionElementKindSectionHeader {
//            header =
//                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
//                                                                      withReuseIdentifier: "header", forIndexPath: indexPath)
//                as? MyCollectionViewHeader
//            
//            header?.arcanaImage.image = UIImage(named: "apple.jpg")
//        }
//        return header!
//        
//    }
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch (section) {
//            
//        
//        case 0: // Attributes
//            return 10
//            
//        case 1: // Values
//            return 10
//        default:
//            return 0
//        }
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        //let cellConstraint = (NSLayoutConstraint(item: cell, attribute: .CenterX, relatedBy: .Equal, toItem: self.collectionView, attribute: .CenterX, multiplier: 1, constant: 0))
//        //cell.addConstraint(cellConstraint)
//        //NSLayoutConstraint.activateConstraints([cellConstraint])
//        switch (indexPath.section) {
//        case 10:
//            return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height * 3/5)
//        default:
//            return CGSizeMake(collectionView.bounds.size.width, 30)
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//       // var cellIdentifier = "
//        
//        switch (indexPath.section) {
//            
//        case 0:
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("attribute", forIndexPath: indexPath) as! ArcanaDetailCell
//            return cell
//
//        default:
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("value", forIndexPath: indexPath) as! ArcanaValueCell
//
//            return cell
//            
//            
////        default:
////            print("DEFAULT")
//        }
//
//    }
//    
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        
//        var attribute = ""
//        
//        if indexPath.section == 0 {
//            
//            let c = cell as! ArcanaDetailCell
//            
//            switch (indexPath.row) {
//                
//            case 0:
//                attribute = "name"
//            case 1:
//                attribute = "rarity"
//            case 2:
//                attribute = "class"
//            case 3:
//                attribute = "affinity"
//            case 4:
//                attribute = "cost"
//            default:
//                break
//                
//            }
//
//            c.attributeKey.text = attribute
//
//        }
//        
//        if indexPath.section == 1 {
//            
//            let c = cell as! ArcanaValueCell
//            
//            switch (indexPath.row) {
//                
//            case 0:
//                attribute = "치도리"
//            case 1:
//                attribute = "SSR"
//            case 2:
//                attribute = "전사"
//            case 3:
//                attribute = "구령"
//            case 4:
//                attribute = "20"
//            default:
//                break
//                
//            }
//            
//            c.attributeValue.text = attribute
//        }
//
//        
//    }
//    
//    
//    
//    func downloadArcana() {
//        do {
//            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
//            // print(htmlSource)
//            
//            // Kanna, search through htmㅣ
//            
//            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
//                // "#id"
//                //                for i in doc.css("#s") {
//                //                    print(i["@scan"])
//                //                }
//                
//                // Search for nodes by XPath
//                //div[@class='ks']
//                
//                // Arcana Attribute Key
//                //th[@class='   js_col_sort_desc ui_col_sort_asc']
//                
//                
//                // Arcana Attribute Value
//                //td[@class='   ']
//                
//                
//                dispatch_async(dispatch_get_global_queue(priority, 0)) {
//                    
//                    
//                    // Fetched required attributes
//                    for (index, link) in doc.xpath("//td[@class='   ']").enumerate() {
//                        
//                        // TODO: Filter needed attributes, then append to attributeValues.
//                        if index >= 41 {
//                            break // Don't need attributes after this point
//                        }
//                        if let attribute = link.text {
//                            if (self.requiredAttributes.contains(index)) {
//                                self.attributeValues.append(attribute)
//                            }
//                            
//                            //print(attribute)
//                        }
//                    }
//                    
//                    // After fetching, print array
//                    dispatch_async(dispatch_get_main_queue()) {
//                        // update some UI
////                        for i in self.attributeValues {
////                            //print(i)
////                        }
//                    }
//                }
//
//            }
//            
//            
//            
//            
//        }
//        catch let error as NSError {
//            print("Ooops! Something went wrong: \(error)")
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        let layout = MyCollectionViewLayout()
////        collectionView.collectionViewLayout = layout
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        downloadArcana()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
