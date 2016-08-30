//
//  ArcanaDetail.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Polyglot

class ArcanaDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var arcanaID: Int?
    
    let downloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .FIFO,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0: // arcanaImage
            return 1
        default: // arcanaAttribute
            return 5
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let line = UIView()
            
            let sepFrame = CGRectMake(10, 0, SCREENWIDTH-20, 2)
            let seperatorView = UIView(frame: sepFrame)
            seperatorView.backgroundColor = UIColor.lightGrayColor()
            line.addSubview(seperatorView)
            
            return line
        default:
            return UIView()
        }

        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch(indexPath.section) {
        case 0:
            return 400
        default:
            return 40
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
            
        case 0: // arcanaImage
            let cell = tableView.dequeueReusableCellWithIdentifier("arcanaImage") as! ArcanaImageCell
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
            
        default:    // arcanaAttribute
            let cell = tableView.dequeueReusableCellWithIdentifier("arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var attributeKey = ""
        var attributeValue = ""
        
        switch (indexPath.section) {
            
        case 0: // arcanaImage
            let c = cell as! ArcanaImageCell
            
            // Check Cache, or download from Firebase
            
            // Check cache first
            if let i = imageCache.imageWithIdentifier("\(indexPath.section)/main") {
                c.arcanaImage.image = i
            }
                
                //  Not in cache, download from firebase
            else {
                
                STORAGE_REF.child("image/arcana/1/main.jpg").downloadURLWithCompletion { (URL, error) -> Void in
                    if (error != nil) {
                        print("image download error")
                        // Handle any errors
                    } else {
                        // Get the download URL
                        self.downloader.downloadImage(URLRequest: NSURLRequest(URL: URL!)) { response in
                            
                            if let image = response.result.value {
                                // Set the Image
                                
                                let size = CGSize(width: SCREENWIDTH - 20, height: 400)
                                
                                let aspectScaledToFitImage = image.af_imageAspectScaledToFitSize(size)
                                
                                c.arcanaImage.image = aspectScaledToFitImage
                                print("DOWNLOADED")
                                
                                // Cache the Image
                                self.imageCache.addImage(image, withIdentifier: "\(indexPath.section)/main")
                                
                            }
                        }
                    }
                }
                
            }
            
            //c.arcanaImage.image = UIImage(named: "apple.jpg")

        default:    // arcanaAttribute
            let c = cell as! ArcanaAttributeCell
            
            switch (indexPath.row) {
                
            case 0:
                attributeKey = "이름"
                attributeValue = "치도리"
            case 1:
                attributeKey = "레어"
                attributeValue = "SSR"
            case 2:
                attributeKey = "직업"
                attributeValue = "전사"
            case 3:
                attributeKey = "소속"
                attributeValue = ""
            case 4:
                attributeKey = "코스트"
                attributeValue = "20"
            default:
                break
                
            }
            
            c.attributeKey.text = attributeKey
            //c.attributeKey.sizeToFit()
            c.attributeValue.text = attributeValue
            //c.attributeKey.sizeToFit()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.delegate = self
        tableView.dataSource = self
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
