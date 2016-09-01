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

class ArcanaDetail: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var arcanaID: Int?
    var arcana: Arcana?

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0: // arcanaImage
            return 1
        case 1: // arcanaAttribute
            return 6
        case 2: // arcanaSkill
            
            // Returning 2 * skillCount for description.
            
            switch arcana!.skillCount {
            case "1":
                return 2
            case "2":
                return 4
            case "3":
                return 6
            default:
                return 2
            }
        
        default:
            return 0
        }
        
    }

//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        switch section {
//        case 2:
//            return UIView()
//        
//        default:
//            let line = UIView()
//            
//            let sepFrame = CGRectMake(10, 5, SCREENWIDTH-20, 2)
//            let seperatorView = UIView(frame: sepFrame)
//            seperatorView.backgroundColor = UIColor.lightGrayColor()
//            line.addSubview(seperatorView)
//            
//            return line
//        }
//
//        
//    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 400
        case 1:
            return 80
        default:
            return UITableViewAutomaticDimension
        }
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    
//        switch indexPath.section {
//        case 0:
//            return 400
//        case 1:
//            return 80
//        default:
//            return UITableViewAutomaticDimension
//        }
//    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0: // arcanaImage
            let cell = tableView.dequeueReusableCellWithIdentifier("arcanaImage") as! ArcanaImageCell
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
            
        case 1:    // arcanaAttribute
            let cell = tableView.dequeueReusableCellWithIdentifier("arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
            
        default:
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            
            guard let arcana = arcana else {
                return tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell
            }
            // Odd rows will be the description
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            //let descCell = tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell

            switch indexPath.row {
            
            case 0,2,4:
                let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
                
                switch indexPath.row {
                    
                case 0:
                    headerCell.skillNumber.text = "스킬 1"
                    headerCell.skillName.text = arcana.skillName1
                    headerCell.skillMana.text = arcana.skillMana1
                    
                case 2:
                    headerCell.skillNumber.text = "스킬 2"
                    headerCell.skillName.text = arcana.skillName2
                    headerCell.skillMana.text = arcana.skillMana2
                default:
                    headerCell.skillNumber.text = "스킬 3"
                    headerCell.skillName.text = arcana.skillName3
                    headerCell.skillMana.text = arcana.skillMana3
    
                }
                
                headerCell.layoutMargins = UIEdgeInsetsZero
                return headerCell

                
            case 1,3,5:
                let descCell = tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell

                switch indexPath.row {
                case 1:
                    descCell.skillAbilityDesc.text = arcana.skillDesc1
                case 3:
                    descCell.skillAbilityDesc.text = arcana.skillDesc2
                default:
                    descCell.skillAbilityDesc.text = arcana.skillDesc3
                    
                }
                descCell.layoutMargins = UIEdgeInsetsZero
                return descCell
                
            default:
                return tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                
            }
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
            
            let size = CGSize(width: SCREENWIDTH - 20, height: 400)
            let aspectScaledToFitImage = UIImage(named: "main.jpg")!.af_imageAspectScaledToFitSize(size)
            c.arcanaImage.image = aspectScaledToFitImage
            
            
            // Check cache first
            /*

            if let i = IMAGECACHE.imageWithIdentifier("\(arcana.uid)/mainThumbnail") {
                print("LOADED CACHE IMAGE")
                
                let size = CGSize(width: SCREENWIDTH - 20, height: 400)
                let aspectScaledToFitImage = i.af_imageAspectScaledToFitSize(size)
                
                c.arcanaImage.image = aspectScaledToFitImage
            }
                
                //  Not in cache, download from firebase
            else {
                c.imageSpinner.startAnimating()
                STORAGE_REF.child("image/arcana/1/main.jpg").downloadURLWithCompletion { (URL, error) -> Void in
                    if (error != nil) {
                        print("image download error")
                        // Handle any errors
                    } else {
                        // Get the download URL
                        DOWNLOADER.downloadImage(URLRequest: NSURLRequest(URL: URL!)) { response in
                            
                            if let image = response.result.value {
                                // Set the Image
                                
                                let size = CGSize(width: SCREENWIDTH - 20, height: 400)
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0)!) {
                                    c.imageSpinner.stopAnimating()
                                    let aspectScaledToFitImage = thumbnail.af_imageAspectScaledToFitSize(size)
                                    
                                    c.arcanaImage.image = aspectScaledToFitImage
                                    
                                    print("DOWNLOADED")
                                    
                                    // Cache the Image
                                    print(arcana.uid)
                                    IMAGECACHE.addImage(thumbnail, withIdentifier: "\(arcana.uid)/mainThumbnail")
                                }
                                

                                
                                
                            }
                        }
                    }
                }
 
            }
 */
 
            
        case 1:    // arcanaAttribute
            let c = cell as! ArcanaAttributeCell
            
            var attributeKey = ""
            var attributeValue = ""
            
            switch (indexPath.row) {
                
            case 0:
                attributeKey = "이름"
                attributeValue = arcana.nameKR
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
            
            // TODO: Calculate # of skills
            
            switch (indexPath.row) {
                
            case 0:
                let headerCell = cell as! ArcanaSkillCell
                headerCell.skillNumber.text = "스킬 1"
                headerCell.skillName.text = arcana.skillName1
                headerCell.skillMana.text = arcana.skillMana1
        
            case 1:
                let descCell = cell as! ArcanaSkillAbilityDescCell
                descCell.skillAbilityDesc.text = arcana.skillDesc1
                
            case 2:
                let headerCell = cell as! ArcanaSkillCell
                headerCell.skillNumber.text = "스킬 2"
                headerCell.skillName.text = arcana.skillName2
                headerCell.skillMana.text = arcana.skillMana2
                
            case 3:
                let descCell = cell as! ArcanaSkillAbilityDescCell
                descCell.skillAbilityDesc.text = arcana.skillDesc2
            case 4:
                let headerCell = cell as! ArcanaSkillCell
                headerCell.skillNumber.text = "스킬 3"
                headerCell.skillName.text = arcana.skillName3
                headerCell.skillMana.text = arcana.skillMana3
            
            case 5:
                let descCell = cell as! ArcanaSkillAbilityDescCell
                descCell.skillAbilityDesc.text = arcana.skillDesc3
                
            default:
                break
                
            }
            
        }
        
    }
    
    func setupViews() {
        
        self.title = "\(arcana!.nameKR)"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        
        // Change Navigation Bar Color based on arcana class
        
        var color = UIColor()
        
        switch(arcana!.group) {
        case "전사":
            color = WARRIORCOLOR
        case "기사":
            color = KNIGHTCOLOR
        case "궁수":
            color = ARCHERCOLOR
        case "법사":
            color = MAGICIANCOLOR
        case "승려":
            color = HEALERCOLOR
        default:
            break
            
        }
        
        self.navigationController!.navigationBar.barTintColor = color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.contentInset = UIEdgeInsetsZero;

        scrollViewDidEndDragging(tableView, willDecelerate: true)
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        
    }

//    override func viewDidAppear(animated: Bool) {
//        
//        tableView.reloadData()
//        
//    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
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
