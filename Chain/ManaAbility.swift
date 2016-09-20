//
//  ManaAbility.swift
//  Chain
//
//  Created by Jitae Kim on 9/12/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
//import Toucan

class ManaAbility: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.tintColor = salmonColor
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var arcanaArray = [Arcana]()
    var currentArray = [Arcana]()
    var group = DispatchGroup()
    let manaTypes = ["전사", "기사", "궁수", "법사", "승려"]
    var selectedIndex = 0
    var abilityType = ""
    var manaArray = [String]()
    
    @IBAction func changeTabs(_ sender: AnyObject) {
        // split this array into the different groups.
        // upon selecting tab in segmented control, switch the tableview's array, and reloaddata.
        // arcanaArray. currentViewArray. 5 group arrays. switch currentviewarray to group array based on the tab selection.
        // somehow reuse this segmented control for every ability??
        switch segmentedControl.selectedSegmentIndex {
            
        case 0: // 전사
            currentArray = arcanaArray.filter({$0.group == "전사"})
        case 1: // 기사
            currentArray = arcanaArray.filter({$0.group == "기사"})
        case 2: // 궁수
            currentArray = arcanaArray.filter({$0.group == "궁수"})
        case 3: // 법사
            currentArray = arcanaArray.filter({$0.group == "법사"})
        default:    // 승려
            currentArray = arcanaArray.filter({$0.group == "승려"})
            
        }
        tableView.reloadData()
    
    }
    // TODO. I download every arcana with ability, but I only display warrior first. 
    
    
    func downloadArray() {
        
        // check if ability or kizuna
        var refSuffix = ""
        
        if selectedIndex == 0 {
            refSuffix = "Ability"
        }
        else {
            refSuffix = "Kizuna"
        }
        
        // Then check ability type
        
        //["마나의 소양", "상자 획득", "골드", "경험치", "서브시 증가", "필살기 증가", "공격력 증가", "보스 웨이브시 공격력 증가"]
        var refPrefix = ""
        
        switch abilityType {
            
            case "마나의 소양":
                refPrefix = "mana"
            case "마나 슬롯 속도":
                refPrefix = "manaSlot"
            case "마나 획득 확률 증가":
                refPrefix = "manaChance"
            case "상자 획득":
                refPrefix = "treasure"
            case "AP 회복":
                refPrefix = "apRecover"
            case "골드":
                refPrefix = "gold"
            case "경험치":
                refPrefix = "exp"
            case "서브시 증가":
                refPrefix = "sub"
            case "필살기 증가":
                refPrefix = "skillUp"
            case "공격력 증가":
                refPrefix = "attackUp"
            case "보스 웨이브시 공격력 증가":
                refPrefix = "bossWaveUp"
            case "어둠 면역":
                refPrefix = "darkImmune"
            case "슬로우 면역":
                refPrefix = "slowImmune"
            case "독 면역":
                refPrefix = "poisonImmune"
        
            default:
                break
            
        }
        
        
        let ref = FIREBASE_REF.child("\(refPrefix)\(refSuffix)")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            var array = [Arcana]()
            
            for id in uid {
                print(id)
                self.group.enter()
                
                let ref = FIREBASE_REF.child("arcana/\(id)")
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    print(snapshot)
                    let arcana = Arcana(snapshot: snapshot)
                    array.append(arcana!)
                    self.group.leave()
                    
                })
                
            }
            
            self.group.notify(queue: DispatchQueue.main, execute: {
                print("Finished all requests.")
                self.arcanaArray = array
                self.currentArray = self.arcanaArray.filter({$0.group == "전사"})
                self.tableView.reloadData()
            })
            
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manaAbility") as! ManaAbilityCell
        cell.arcanaImage.image = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let c = cell as! ManaAbilityCell
        
        c.arcanaNameKR.text = currentArray[(indexPath as NSIndexPath).row].nameKR
        c.arcanaNameJP.text = currentArray[(indexPath as NSIndexPath).row].nameJP
        c.arcanaRarity.text = "#\(currentArray[(indexPath as NSIndexPath).row].rarity)★"
        
        
        // Get abilities, kizuna, group
        let aD1 = currentArray[(indexPath as NSIndexPath).row].abilityDesc1
        let g = currentArray[(indexPath as NSIndexPath).row].group
        var aD2 = ""
        if let a = currentArray[(indexPath as NSIndexPath).row].abilityDesc2 {
            aD2 = a
        }
        let k = currentArray[(indexPath as NSIndexPath).row].kizunaDesc
        
        // check for the abilityType, then perform operation.
        
        // also check if it needs the label for percent
        
        switch abilityType {
            
        case "마나의 소양":
            c.value.isHidden = true
            getMana(aD1, aD2: aD2, k: k, g: g)
            c.mana1.mana = manaArray[0]
            if manaArray.count > 1 {
                c.mana2.mana = manaArray[1]
            }
            
        case "AP 회복":
            c.value.text = "30%"
            //do ap stuff
        default:
            break
        }
        
        c.imageSpinner.startAnimating()
      //  c.mana2.mana = manaArray[1]
      //  c.manaSub.mana = manaArray[2]

        // Download picture
        /*
        // Check cache first
        if let i = IMAGECACHE.imageWithIdentifier("\(currentArray[indexPath.row].uid)/icon.jpg") {
            
            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
            let crop = Toucan(image: i).resize(c.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
            
            //            let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
            c.arcanaImage.image = crop
        }
            
            //  Not in cache, download from firebase
        else {
            c.imageSpinner.startAnimation()
            
            STORAGE_REF.child("image/arcana/\(currentArray[indexPath.row].uid)/icon.jpg").downloadURLWithCompletion { (URL, error) -> Void in
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
                            
                            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
                            
                            
                            if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {
                                c.imageSpinner.stopAnimation()
                                
                                let crop = Toucan(image: thumbnail).resize(c.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
                                //let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
                                c.arcanaImage.image = crop
                                
                                print("DOWNLOADED")
                                
                                // Cache the Image
                                IMAGECACHE.addImage(thumbnail, withIdentifier: "\(self.currentArray[indexPath.row].uid)/icon.jpg")
                            }
                            
                            
                        }
                    }
                }
            }
            
        }
        
        */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegueWithIdentifier("showArcana", sender: indexPath.row)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let vc = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        vc.arcana = currentArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]

        // If you want to push to new ViewController then use this
        self.navigationController?.pushViewController(vc, animated: true)


    }
    
    
    func getMana(_ aD1: String, aD2: String, k: String, g: String) -> Bool {
        
        if aD1 != "" && aD1.contains("마나를") {
//            print("ability 1")
            if aD1.contains("2") {
                manaArray.append(g)
                manaArray.append(g)
            }
            else {
                manaArray.append(g)
                // also check if it gives different class mana
                if aD1.contains("추가된다") {
                    for mana in manaTypes {
                        if aD1.contains(mana) && mana != g {
                            manaArray.append(mana)
                        }
                        
                    }
                }
            }
            
        }
        
        if aD2 != "" {
//            print("ability 2")
            if aD2.contains("마나를") {
                if aD2.contains("2") {
                    print("FOUND 2")
                    manaArray.append(g)
                    manaArray.append(g)
                }
                else {
                    manaArray.append(g)
                    // also check if it gives different class mana
                    if aD2.contains("추가된다") {
                        for mana in manaTypes {
                            if aD2.contains(mana) && mana != g {
                                manaArray.append(mana)
                            }
                            
                        }
                    }
                }
            }
            
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "마나"
        tableView.delegate = self
        tableView.dataSource = self
        downloadArray()
        segmentedControl.selectedSegmentIndex = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let objSomeViewController = storyBoard.instantiateViewControllerWithIdentifier("ArcanaDetail") as! ArcanaDetail
//        
//        // If you want to push to new ViewController then use this
//        self.navigationController?.pushViewController(objSomeViewController, animated: true)
        
//        if segue.identifier == "showArcana" {
//            let vc = segue.destinationViewController as! ArcanaDetail
//            vc.arcana = currentArray[tableView.indexPathForSelectedRow!.row]
//        }
//    }
    
    

}
