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
    var arcana: Arcana?
    
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
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0: // arcanaImage
            return 1
        case 1: // arcanaAttribute
            return 6
        default:
            
            // TODO: Calculate # of skills arcana has (1, 2, or 3)
            return 2
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch section {
        case 2:
            return UIView()
        
        default:
            let line = UIView()
            
            let sepFrame = CGRectMake(10, 5, SCREENWIDTH-20, 2)
            let seperatorView = UIView(frame: sepFrame)
            seperatorView.backgroundColor = UIColor.lightGrayColor()
            line.addSubview(seperatorView)
            
            return line
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
            
        case 1:    // arcanaAttribute
            let cell = tableView.dequeueReusableCellWithIdentifier("arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let arcana = arcana
            else {
                print("ARCANA IS NOT INITIALIZED!")
                return
            }
        
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

        case 1:    // arcanaAttribute
            let c = cell as! ArcanaAttributeCell
            
            var attributeKey = ""
            var attributeValue = ""
            
            switch (indexPath.row) {
                
            case 0:
                attributeKey = "이름"
                attributeValue = arcana.name
            case 1:
                attributeKey = "레어"
                attributeValue = arcana.rarity
            case 2:
                attributeKey = "직업"
                attributeValue = arcana.group
            case 3:
                attributeKey = "소속"
                attributeValue = arcana.affiliation
            case 4:
                attributeKey = "코스트"
                attributeValue = arcana.cost
            case 5:
                attributeKey = "무기"
                attributeValue = arcana.weapon
                
            default:
                break
                
            }
            
            c.attributeKey.text = attributeKey
            //c.attributeKey.sizeToFit()
            c.attributeValue.text = attributeValue
            //c.attributeKey.sizeToFit()
            
        default:
            let c = cell as! ArcanaSkillCell
            
            // TODO: Calculate # of skills
            
            switch (indexPath.row) {
                
            case 0:
                c.skillNumber.text = "1"
                c.skillName.text = arcana.skillName1
                c.skillMana.text = arcana.skillMana1
            case 1:
                c.skillNumber.text = "2"
                c.skillName.text = arcana.skillName2
                c.skillMana.text = arcana.skillMana2
            case 2:
                c.skillNumber.text = "3"
                c.skillName.text = arcana.skillName3
                c.skillMana.text = arcana.skillMana3

                
            default:
                break
                
            }
            
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
