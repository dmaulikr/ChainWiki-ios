//
//  ArcanaDetail.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage
import NVActivityIndicatorView

class ArcanaDetail: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    var arcanaID: Int?
    var arcana: Arcana?
    var heart = false
    var favorite = false

    
    @IBAction func edit(_ sender: AnyObject) {
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let _ = user {
                print("ALLOWED TO EDIT, push view")
                self.performSegue(withIdentifier: "editArcana", sender: self)
                
            }
            else {
                let alertController = UIAlertController(title: "권한 없음", message: "로그인하면 수정할 수 있습니다.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func checkFavorites() {
        // TODO: when favoriting, automatically like. when cancelling, only cancel one.
        if let arcana = arcana {
            
            let favRef = FIREBASE_REF.child("user/\(UserDefaults.standard.value(forKey: "uid"))/favorites/\(arcana.uid)")
            let heartRef = FIREBASE_REF.child("user/\(UserDefaults.standard.value(forKey: "uid"))/likes/\(arcana.uid)")
            favRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    print("favorited already")
                    self.favorite = true
                }
                else {
                    print("not favorited")
                }
            })
            
            heartRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    print("liked already")
                    self.heart = true
                }
                else {
                    print("not liked")
                }
            })
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let arcana = arcana else {
            return 0
        }
        
        switch (section) {
        case 0: // arcanaImage
            return 1
        case 1: // arcanaAttribute
            return 6
        case 2: // arcanaSkill
            
            // Returning 2 * skillCount for description.
            
            switch arcana.skillCount {
            case "1":
                return 2
            case "2":
                return 4
            case "3":
                return 6
            default:
                return 2
            }
        
        case 3:    // Arcana abilities. TODO: Check for 0, 1, 2 abilities.
            
            if let _ = arcana.abilityName2 {    // has 2 abilities
                return 4
            }
            else {  // has only 1 ability
                return 2
            }
            
        case 4:    // Kizuna
            return 2
            
        default:    // chainstory, chainstone
            var count = 0
            if let _ = arcana.chainStory {
                count += 1
            }
            if let _ = arcana.chainStone {
                count += 1
            }
            
            return count
        
        }
  
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            return SCREENHEIGHT * 3/5
            
        case 1:
            if (indexPath as NSIndexPath).row == 0 {
                return 160
            }
            else {
                return 80
            }
        case 3:
            return 80
        default:
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let arcana = arcana else {
            return UITableViewCell()
        }
        switch (indexPath as NSIndexPath).section {
            
        case 0: // arcanaImage
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaImage") as! ArcanaImageCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.favorite.tag = indexPath.row
            cell.heart.tag = indexPath.row
            
            if favorite {
                cell.favorite.setBackgroundImage(_: UIImage(named: "emailSalmon"), for: .normal)
            }
            if heart {
                cell.heart.setBackgroundImage(_: UIImage(named: "emailSalmon"), for: .normal)
            }
            
            cell.imageSpinner.startAnimating()
            
            if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/main.jpg") {
                print("LOADED CACHE IMAGE")
                
                let size = CGSize(width: SCREENWIDTH - 20, height: 400)
                let aspectScaledToFitImage = i.af_imageAspectScaled(toFit: size)
                
                cell.arcanaImage.image = aspectScaledToFitImage
                cell.imageSpinner.stopAnimating()
            }
                
                //  Not in cache, download from firebase
            else {
                //                c.imageSpinner.startAnimation()
                STORAGE_REF.child("image/arcana/\(arcana.uid)/main.jpg").downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                        print("image download error")
                        // Handle any errors
                    } else {
                        // Get the download URL
                        let urlRequest = URLRequest(url: URL!)
                        
                        DOWNLOADER.download(urlRequest) { response in
                            
                            if let image = response.result.value {
                                // Set the Image
                                
                                let size = CGSize(width: (SCREENWIDTH - CGFloat(20)), height: 400)
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0)!) {
                                    cell.imageSpinner.stopAnimating()
                                    let aspectScaledToFitImage = thumbnail.af_imageAspectScaled(toFit: size)
                                    
                                    cell.arcanaImage.image = aspectScaledToFitImage
                                    
                                    print("DOWNLOADED")
                                    
                                    // Cache the Image
                                    print(arcana.uid)
                                    IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/main.jpg")
                                }
                                
                                
                                
                                
                            }
                        }
                    }
                }
                
            }
            
            return cell
            
        case 1:    // arcanaAttribute
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsets.zero
            
            var attributeKey = ""
            var attributeValue = ""
            
            switch (indexPath as NSIndexPath).row {
                
            case 0:
                attributeKey = "이름"
                if let nnKR = arcana.nickNameKR, let nnJP = arcana.nickNameJP {
                    attributeValue = "\(nnKR) \(arcana.nameKR)\n\(nnJP) \(arcana.nameJP)"
                    
                }
                else {
                    attributeValue = "\(arcana.nameKR)\n\(arcana.nameJP)"
                }
            case 1:
                attributeKey = "레어"
                attributeValue = getRarityLong(arcana.rarity)
            case 2:
                attributeKey = "직업"
                attributeValue = arcana.group
            case 3:
                attributeKey = "소속"
                if let a = arcana.affiliation {
                    attributeValue = a
                }
            case 4:
                attributeKey = "코스트"
                attributeValue = arcana.cost
            case 5:
                attributeKey = "무기"
                attributeValue = arcana.weapon
                
            default:
                break
                
            }
            
            cell.attributeKey.text = attributeKey
            cell.attributeValue.text = attributeValue
            
            return cell
            
        case 2: // Arcana Skill
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            
            
            // Odd rows will be the description
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            //let descCell = tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell

            switch (indexPath as NSIndexPath).row {
            
            case 0,2,4:
                let headerCell = tableView.dequeueReusableCell(withIdentifier: "arcanaSkill") as! ArcanaSkillCell
                
                switch (indexPath as NSIndexPath).row {
                    
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
                
                headerCell.layoutMargins = UIEdgeInsets.zero
                return headerCell

                
            case 1,3,5:
                let descCell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell

    
                switch (indexPath as NSIndexPath).row {
                case 1:
                    descCell.skillAbilityDesc.text = arcana.skillDesc1
                case 3:
                    descCell.skillAbilityDesc.text = arcana.skillDesc2
                default:
                    descCell.skillAbilityDesc.text = arcana.skillDesc3
                    
                }
                descCell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                descCell.layoutMargins = UIEdgeInsets.zero
                return descCell
                
            default:
                return tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                
            }
            
            // Arcana Ability
        case 3:
            
            switch (indexPath as NSIndexPath).row {
            case 0,2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
                
                if (indexPath as NSIndexPath).row == 0 {
                    cell.attributeKey.text = "어빌 1"
                    cell.attributeValue.text = arcana.abilityName1
                    
                }
                else {
                    cell.attributeKey.text = "어빌 2"
                    cell.attributeValue.text = arcana.abilityName2
                }
                
                cell.layoutMargins = UIEdgeInsets.zero
                return cell


            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell

                
                if indexPath.row == 1 {
                    
//                    let paragraphStyle = NSMutableParagraphStyle()
//                    //line height size
//                    paragraphStyle.lineSpacing = 10
//                    let attrString = NSMutableAttributedString(string: arcana.abilityDesc1)
//                    attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//                    cell.skillAbilityDesc.attributedText = attrString
                    cell.skillAbilityDesc.text = arcana.abilityDesc1
                    

                }
                else {
                    cell.skillAbilityDesc.text = arcana.abilityDesc2
                }
                
                cell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
        case 4:
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaSkill") as! ArcanaSkillCell
                cell.skillName.text = arcana.kizunaName
                cell.skillMana.text = arcana.kizunaCost
                cell.layoutMargins = UIEdgeInsets.zero
                return cell

            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                cell.skillAbilityDesc.text = arcana.kizunaDesc
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
            
        default:
            if let cStory = arcana.chainStory {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chainStory") as! ArcanaChainStory
                cell.storyKey.text = "체인스토리"
                cell.storyAttribute.text = cStory
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            } else if let cStone = arcana.chainStone {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chainStory") as! ArcanaChainStory
                cell.storyKey.text = "인연이야기"
                cell.storyAttribute.text = cStone
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
            else {
                assert(false, "unexpected element kind")
            }
        }
        
        
            
    }
    
    
    /*
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let arcana = arcana
            else {
                print("ARCANA IS NOT INITIALIZED!")
                return
            }
        
        switch ((indexPath as NSIndexPath).section) {
            
        case 0: // arcanaImage

            let c = cell as! ArcanaImageCell
            
            

            // Check Cache, or download from Firebase
            
//            let size = CGSize(width: SCREENWIDTH - 20, height: 400)
//            let aspectScaledToFitImage = UIImage(named: "main.jpg")!.af_imageAspectScaledToFitSize(size)
//            c.arcanaImage.image = aspectScaledToFitImage
            
            
            // Check cache first
            
            
            if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/main.jpg") {
                print("LOADED CACHE IMAGE")
                
                let size = CGSize(width: SCREENWIDTH - 20, height: 400)
                let aspectScaledToFitImage = i.af_imageAspectScaled(toFit: size)
                
                c.arcanaImage.image = aspectScaledToFitImage
                c.imageSpinner.stopAnimating()
            }
                
                //  Not in cache, download from firebase
            else {
//                c.imageSpinner.startAnimation()
                STORAGE_REF.child("image/arcana/\(arcana.uid)/main.jpg").downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                        print("image download error")
                        // Handle any errors
                    } else {
                        // Get the download URL
                        let urlRequest = URLRequest(url: URL!)

                        DOWNLOADER.download(urlRequest) { response in
                            
                            if let image = response.result.value {
                                // Set the Image
                                
                                let size = CGSize(width: (SCREENWIDTH - CGFloat(20)), height: 400)
                                
                                if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0)!) {
                                    c.imageSpinner.stopAnimating()
                                    let aspectScaledToFitImage = thumbnail.af_imageAspectScaled(toFit: size)
                                    
                                    c.arcanaImage.image = aspectScaledToFitImage
                                    
                                    print("DOWNLOADED")
                                    
                                    // Cache the Image
                                    print(arcana.uid)
                                    IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/main.jpg")
                                }
                                

                                
                                
                            }
                        }
                    }
                }
 
            }
 
 
            
        case 1:    // arcanaAttribute
            let c = cell as! ArcanaAttributeCell
            
            var attributeKey = ""
            var attributeValue = ""
            
            switch (indexPath as NSIndexPath).row {
                
            case 0:
                attributeKey = "이름"
                if let nnKR = arcana.nickNameKR, let nnJP = arcana.nickNameJP {
                    attributeValue = "\(nnKR) \(arcana.nameKR)\n\(nnJP) \(arcana.nameJP)"

                }
                else {
                    attributeValue = "\(arcana.nameKR)\n\(arcana.nameJP)"
                }
            case 1:
                attributeKey = "레어"
                attributeValue = getRarityLong(arcana.rarity)
            case 2:
                attributeKey = "직업"
                attributeValue = arcana.group
            case 3:
                attributeKey = "소속"
                if let a = arcana.affiliation {
                    attributeValue = a
                }
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
            c.attributeValue.text = attributeValue
            
        case 2:
            
            // TODO: Calculate # of skills
            
            switch (indexPath as NSIndexPath).row {
                
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
        case 3:
            switch (indexPath as NSIndexPath).row {
                
            case 0:
                let name = cell as! ArcanaAttributeCell
                name.attributeKey.text = "어빌 1"
                name.attributeValue.text = arcana.abilityName1
            case 1:
                let desc = cell as! ArcanaSkillAbilityDescCell
                
                let paragraphStyle = NSMutableParagraphStyle()
                //line height size
                paragraphStyle.lineSpacing = 5
                let attrString = NSMutableAttributedString(string: arcana.abilityDesc1)
                attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                desc.skillAbilityDesc.attributedText = attrString
                
//                desc.skillAbilityDesc.text = arcana.abilityDesc1
            case 2:
                let name = cell as! ArcanaAttributeCell
                name.attributeKey.text = "어빌 2"
                name.attributeValue.text = arcana.abilityName2
            default:
                let desc = cell as! ArcanaSkillAbilityDescCell
                desc.skillAbilityDesc.text = arcana.abilityDesc2
                
            }
        case 4:
            switch (indexPath as NSIndexPath).row {
            case 0:
                let descCell = cell as! ArcanaSkillCell
                descCell.skillNumber.text = "인연"
                descCell.skillManaCost.text = "코스트"
            default:
                break
                
                
            }
            
        default:
            break
            
            
        }
        
    }
    
    */
//    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.backgroundColor = UIColor.redColor()
//    }
//    
//    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.backgroundColor = UIColor.greenColor()
//    }
    func setupViews() {
        
        self.title = "\(arcana!.nameKR)"
        self.tableView.backgroundColor = UIColor.white
    }
    
    
    func getRarityLong(_ string: String) -> String {
        
        switch string {
            
        case "5★", "5":
            return "★★★★★SSR"
        case "4★", "4":
            return "★★★★SR"
        case "3★", "3":
            return "★★★R"
        case "2★", "2":
            return "★★HN"
        case "1★", "1":
            return "★N"
        default:
            return "업데이트 필요"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero;

        scrollViewDidEndDragging(tableView, willDecelerate: true)
        
        checkFavorites()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Increment number of views
        let viewRef = FIREBASE_REF.child("arcana/\(arcana!.uid)/numberOfViews")
        viewRef.observeSingleEvent(of: .value, with: { snapshot in
            let views = snapshot.value as! Int
            print("numberOfViews is \(views)")
            viewRef.setValue(views+1)            
        })

        //navigationController?.hidesBarsOnSwipe = true
    
    }

//    override func viewDidAppear(animated: Bool) {
//        
//        tableView.reloadData()
//        
//    }
    


    override func viewDidDisappear(_ animated: Bool) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "editArcana") {
            
            let vc = segue.destination as! ArcanaDetailEdit
            vc.arcana = arcana
            
            
        }
    }

}
