
//  ViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
//import Toucan
import NVActivityIndicatorView

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filter: UIBarButtonItem!

    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    let filterUpdate = Filter()
    var rarityArray = [String]()
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showArcana", sender: (indexPath as NSIndexPath).row)
    }
    
    func downloadArray() {

        let ref = FIREBASE_REF.child("arcana")

        ref.queryLimited(toLast: 20).observe(.value, with: { snapshot in
            
            var filter = [Arcana]()
            for item in snapshot.children {
                let arcana = Arcana(snapshot: item as! FIRDataSnapshot)
                filter.append(arcana!)
            }
            self.arcanaArray = filter.reversed()
            self.originalArray = filter.reversed()
            self.tableView.reloadData()
        })
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        cell.arcanaImage.image = nil
        //let image = UIImage(named: "main.jpg")!
//        let image = Toucan(image: UIImage(named: "main.jpg")!).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//        cell.arcanaImage.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let c = cell as! ArcanaCell
        // check if arcana has only name, or nickname.
        if let nnKR = arcanaArray[(indexPath as NSIndexPath).row].nickNameKR, let nnJP = arcanaArray[(indexPath as NSIndexPath).row].nickNameJP {
            c.arcanaNickJP.text = nnJP
            c.arcanaNickKR.text = nnKR

//            let combinedNameKR = "\(nnKR) \(arcanaArray[indexPath.row].nameKR)"
//            c.arcanaNameKR.text = combinedNameKR
//            let combinedNameJP = "\(nnJP) \(arcanaArray[indexPath.row].nameJP)"
//            c.arcanaNameJP.text = combinedNameJP
        }
            c.arcanaNameKR.text = arcanaArray[(indexPath as NSIndexPath).row].nameKR
            c.arcanaNameJP.text = arcanaArray[(indexPath as NSIndexPath).row].nameJP
        
        
        
        
//        var rarityPreview = ""
//        switch(arcanaArray[indexPath.row].rarity) {
//            case "★★★★★SSR":
//                rarityPreview = "5★"
//            case "★★★★SR":
//                rarityPreview = "4★"
//            case "★★★R":
//                rarityPreview = "3★"
//            case "★★HN":
//                rarityPreview = "2★"
//            case "★N":
//                rarityPreview = "1★"
//            default:
//                break
//        }
        c.arcanaRarity.text = "#\(arcanaArray[(indexPath as NSIndexPath).row].rarity)★"
        c.arcanaGroup.text = "#\(arcanaArray[(indexPath as NSIndexPath).row].group)"
        c.arcanaWeapon.text = "#\(arcanaArray[(indexPath as NSIndexPath).row].weapon)"
        if let a = arcanaArray[(indexPath as NSIndexPath).row].affiliation {
            c.arcanaAffiliation.text = "#\(a)"
        }
       
        c.arcanaImage.image = nil
//        c.imageSpinner.startAnimation()
        print("animated")
        // Check Cache, or download from Firebase
       // c.arcanaImage.image = UIImage(named: "main.jpg")
        //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
//        let image = Toucan(image: UIImage(named: "main.jpg")!).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//        cell.arcanaImage.image = image
        
//        var borderColor = UIColor()
//        switch arcanaArray[indexPath.row].group {
//            case "전사":
//            borderColor = WARRIORCOLOR
//            case "기사":
//            borderColor = KNIGHTCOLOR
//            case "궁수":
//            borderColor = ARCHERCOLOR
//            case "법사":
//            borderColor = MAGICIANCOLOR
//        default:
//            borderColor = HEALERCOLOR
//        }
        
        
        
        
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcanaArray[indexPath.row].uid)/icon.jpg") {
            
            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
//            let crop = Toucan(image: i).resize(c.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
            
//            let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
//            c.arcanaImage.image = crop
        }
         
            //  Not in cache, download from firebase
        else {
            c.imageSpinner.startAnimation()

            STORAGE_REF.child("image/arcana/\(arcanaArray[indexPath.row].uid)/icon.jpg").downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    print("image download error")
                    // Handle any errors
                } else {
                    // Get the download URL
                    print("DOWNLOAD URL = \(URL!)")
                    let urlRequest = URLRequest(url: URL!)
                    DOWNLOADER.download(urlRequest) { response in
                        
                        if let image = response.result.value {
                            // Set the Image
                            
                            // TODO: MAKE SMALL THUMBNAIL
                            
                            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)

                            
                            if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {
                                c.imageSpinner.stopAnimation()

//                                let crop = Toucan(image: thumbnail).resize(c.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//                                //let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
//                                c.arcanaImage.image = crop
                                
                                print("DOWNLOADED")
                                
                                // Cache the Image
                                IMAGECACHE.add(thumbnail, withIdentifier: "\(self.arcanaArray[indexPath.row].uid)/icon.jpg")
                            }

                            
                        }
                    }
                }
            }
            
        }
    

    }
    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadArray()
        //dict.updateValue(testArc!, forKey: "OI")
        //filterArray()
        self.navigationController?.navigationController?.title = "아르카나"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
//        if let scv = self.parentViewController as? SegmentedContainerView {
//            print("LOADED CONTAINER VIEW")
//            arcanaArray = scv.arcanaArray
//        }
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

       // tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showArcana") {
            let vc = segue.destination as! ArcanaDetail
            vc.arcana = arcanaArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        }
    }

    
}


