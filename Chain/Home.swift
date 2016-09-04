//
//  ViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Polyglot


class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBAction func indexChanged(sender: AnyObject) {
    }
    @IBOutlet weak var tableView: UITableView!
    
    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()

    
//    let downloader = ImageDownloader(
//        configuration: ImageDownloader.defaultURLSessionConfiguration(),
//        downloadPrioritization: .FIFO,
//        maximumActiveDownloads: 4,
//        imageCache: AutoPurgingImageCache()
//    )
//    
//    let imageCache = AutoPurgingImageCache(
//        memoryCapacity: 100 * 1024 * 1024,
//        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
//    )
    

    var rarityArray = [String]()
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showArcana") {
            let vc = segue.destinationViewController as! ArcanaDetail
            vc.arcana = arcanaArray[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showArcana", sender: indexPath.row)
    }
    
//    func filterArray() {
//
//        let ref = FIREBASE_REF.child("arcana")
//
//        ref.queryLimitedToLast(20).observeEventType(.Value, withBlock: { snapshot in
//            
//            var filter = [Arcana]()
//            for item in snapshot.children {
//                let arcana = Arcana(snapshot: item as! FIRDataSnapshot)
//                filter.append(arcana!)
//            }
//            self.arcanaArray = filter
//            self.tableView.reloadData()
//        })
//        
//    }
//    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SCREENHEIGHT/7
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("arcanaCell") as! ArcanaCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let c = cell as! ArcanaCell
        c.arcanaNameKR.text = arcanaArray[indexPath.row].nameKR
        c.arcanaNameJP.text = arcanaArray[indexPath.row].nameJP
        c.arcanaWeapon.text = arcanaArray[indexPath.row].weapon
        
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
        c.arcanaRarity.text = arcanaArray[indexPath.row].rarity
        
        // Check Cache, or download from Firebase
        c.arcanaImage.image = UIImage(named: "main.jpg")
        
  /*
        // Check cache first
        if let i = IMAGECACHE.imageWithIdentifier("\(arcanaArray[indexPath.row].uid)/cellThumbnail") {
            
            let size = CGSize(width: SCREENHEIGHT/7, height: SCREENHEIGHT/7)
            let aspectScaledToFitImage = i.af_imageAspectScaledToFitSize(size)
            
            c.arcanaImage.image = aspectScaledToFitImage
        }
            
            //  Not in cache, download from firebase
        else {
            print("UID \(arcanaArray[indexPath.row].uid)")
            
            STORAGE_REF.child("image/arcana/\(arcanaArray[indexPath.row].uid)/main.jpg").downloadURLWithCompletion { (URL, error) -> Void in
                if (error != nil) {
                    print("image download error")
                    // Handle any errors
                } else {
                    // Get the download URL
                    print("DOWNLOAD URL = \(URL!)")
                    DOWNLOADER.downloadImage(URLRequest: NSURLRequest(URL: URL!)) { response in
                        
                        if let image = response.result.value {
                            // Set the Image
                            
                            // TODO: MAKE SMALL THUMBNAIL
                            
                            let size = CGSize(width: SCREENHEIGHT/7, height: SCREENHEIGHT/7)
                            
                            if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0.0)!) {
                                
                                let aspectScaledToFitImage = thumbnail.af_imageAspectScaledToFitSize(size)
                                
                                c.arcanaImage.image = aspectScaledToFitImage
                                print("DOWNLOADED")
                                
                                // Cache the Image
                                IMAGECACHE.addImage(thumbnail, withIdentifier: "\(self.arcanaArray[indexPath.row].uid)/cellThumbnail")
                            }

                            
                        }
                    }
                }
            }
            
        }
    */

    }
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //dict.updateValue(testArc!, forKey: "OI")
        //filterArray()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let scv = self.parentViewController as? SegmentedContainerView {
            print("LOADED CONTAINER VIEW")
            arcanaArray = scv.arcanaArray
        }
        self.tableView.reloadData()
        
        print("VIEW CHANGED")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


