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

class AbilityView: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
                refPrefix = "bossWave"
            case "어둠 면역":
                refPrefix = "darkImmune"
            case "슬로우 면역":
                refPrefix = "slowImmune"
            case "독 면역":
                refPrefix = "poisonImmune"
        
            default:
                break
            
        }
        
        print("REF IS \(refPrefix)\(refSuffix)")
        let ref = FIREBASE_REF.child("\(refPrefix)\(refSuffix)")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            var array = [Arcana]()
            
            for id in uid {
                self.group.enter()
                
                let ref = FIREBASE_REF.child("arcana/\(id)")
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                    }
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        
        for i in cell.labelCollection {
            i.text = nil
        }
        cell.arcanaImage.image = nil
        
        cell.imageSpinner.startAnimating()
        
        let arcana = currentArray[indexPath.row]
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.nickNameKR {
            cell.arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.nickNameJP {
            
            cell.arcanaNickJP.text = nnJP
            
        }
        cell.arcanaNameKR.text = arcana.nameKR
        cell.arcanaNameJP.text = arcana.nameJP
        
        cell.arcanaRarity.text = "#\(arcana.rarity)★"
        cell.arcanaGroup.text = "#\(arcana.group)"
        cell.arcanaWeapon.text = "#\(arcana.weapon)"
        if let a = arcana.affiliation {
            if a != "" {
                cell.arcanaAffiliation.text = "#\(a)"
            }
            
        }
        
        cell.numberOfViews.text = "조회 \(arcana.numberOfViews)"
        cell.arcanaUID = arcana.uid
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg") {
            
            cell.arcanaImage.image = i
            cell.imageSpinner.stopAnimating()
            print("LOADED FROM CACHE")
            
        }
            
        else {
            
            STORAGE_REF.child("image/arcana/\(arcana.uid)/icon.jpg").downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    print("image download error")
                    
                    // Handle any errors
                } else {
                    // Get the download URL
                    let urlRequest = URLRequest(url: URL!)
                    DOWNLOADER.download(urlRequest) { response in
                        
                        if let image = response.result.value {
                            // Set the Image
                            
                            if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {
                                
                                // Cache the Image
                                IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/icon.jpg")
                                cell.imageSpinner.stopAnimating()
                                
                                if cell.arcanaUID == arcana.uid {
                                    cell.arcanaImage.image = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg")
                                    cell.arcanaImage.alpha = 0
                                    cell.arcanaImage.fadeIn()
                                }
                                
                                
                                print("DOWNLOADED")
                                
                                
                            }
                            else {
                                print("COULD NOT UNWRAP IMAGE")
                            }
                            
                            
                        }
                    }
                }
            }
            
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegueWithIdentifier("showArcana", sender: indexPath.row)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let vc = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        vc.arcana = currentArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]

        // If you want to push to new ViewController then use this
        self.navigationController?.pushViewController(vc, animated: true)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = abilityType
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        
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
