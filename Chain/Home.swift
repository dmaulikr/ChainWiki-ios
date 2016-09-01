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

    @IBOutlet weak var tableView: UITableView!
    @IBAction func translate(sender: AnyObject) {
        
        TRANSLATOR.fromLanguage = Language.Japanese
        TRANSLATOR.toLanguage = Language.Korean
        
        let text = "斬空剣"
        TRANSLATOR.translate(text) { translate in
            print(translate)
        }
    }

    @IBOutlet weak var translate: UIButton!
    var dict = [String: Arcana]()
    
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
    
    var filteredArray = [Arcana]()
    var rarityArray = [String]()
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showArcana") {
            let vc = segue.destinationViewController as! ArcanaDetail
            vc.arcana = filteredArray[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showArcana", sender: indexPath.row)
    }
    
    func filterArray() {

        let ref = FIREBASE_REF.child("arcana")

        ref.queryLimitedToLast(20).observeEventType(.ChildAdded, withBlock: { snapshot in
            var filter = [Arcana]()
            print(snapshot)
            let arcana = Arcana(snapshot: snapshot)
            filter.append(arcana!)
            
            self.filteredArray = filter
            self.tableView.reloadData()
        })
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
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
        c.arcanaNameKR.text = filteredArray[indexPath.row].nameKR
        c.arcanaNameJP.text = filteredArray[indexPath.row].nameJP
        c.arcanaWeapon.text = filteredArray[indexPath.row].weapon
        
        var rarityPreview = ""
        switch(filteredArray[indexPath.row].rarity) {
            case "★★★★★SSR":
                rarityPreview = "5★"
            case "★★★★★SSR":
                rarityPreview = "4★"
            case "★★★★★SSR":
                rarityPreview = "3★"
            case "★★★★★SSR":
                rarityPreview = "2★"
            case "★★★★★SSR":
                rarityPreview = "1★"
            default:
                break
        }
        c.arcanaRarity.text = rarityPreview
        
        // Check Cache, or download from Firebase
        c.arcanaImage.image = UIImage(named: "main.jpg")
        
        /*
        // Check cache first
        if let i = IMAGECACHE.imageWithIdentifier("\(filteredArray[indexPath.row].uid)/cellThumbnail") {
            
            let size = CGSize(width: SCREENHEIGHT/7, height: SCREENHEIGHT/7)
            let aspectScaledToFitImage = i.af_imageAspectScaledToFitSize(size)
            
            c.arcanaImage.image = aspectScaledToFitImage
        }
            
            //  Not in cache, download from firebase
        else {
            
            STORAGE_REF.child("image/arcana/1/main.jpg").downloadURLWithCompletion { (URL, error) -> Void in
                if (error != nil) {
                    print("image download error")
                    // Handle any errors
                } else {
                    // Get the download URL
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
                                IMAGECACHE.addImage(thumbnail, withIdentifier: "\(self.filteredArray[indexPath.row].uid)/cellThumbnail")
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
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        //dict.updateValue(testArc!, forKey: "OI")
        filterArray()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


