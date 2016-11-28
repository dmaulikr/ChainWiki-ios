

//
//  ArcanaAbilityDB.swift
//  Chain
//
//  Created by Jitae Kim on 8/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var preventAnimation = Set<IndexPath>()
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.tintColor = Color.salmon
        }
    }
    
    let arcanaArray = [Arcana]()
    var currentArray = [String]()
    // TODO. remember user's last preference.
    let abilityArray = ["마나의 소양", "상자 획득", "AP 회복", "골드", "경험치", "서브시 증가", "마나 슬롯 속도", "마나 획득 확률 증가"]
    let kizunaArray = ["마나의 소양", "상자 획득", "골드", "경험치", "서브시 증가", "필살기 증가", "공격력 증가", "보스 웨이브시 공격력 증가", "어둠 면역", "슬로우 면역", "독 면역", "마나 슬롯 속도", "마나 획득 확률 증가"]
    
    let abilityImages = [#imageLiteral(resourceName: "mana"), #imageLiteral(resourceName: "treasure"), #imageLiteral(resourceName: "apRecovery"), #imageLiteral(resourceName: "gold"), #imageLiteral(resourceName: "exp"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "darknessImmune"), #imageLiteral(resourceName: "slowImmune"), #imageLiteral(resourceName: "poisonImmune"), #imageLiteral(resourceName: "manaSlot"), #imageLiteral(resourceName: "manaChance")]
    let kizunaImages = [#imageLiteral(resourceName: "mana"), #imageLiteral(resourceName: "treasure"), #imageLiteral(resourceName: "gold"), #imageLiteral(resourceName: "exp"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "darknessImmune"), #imageLiteral(resourceName: "slowImmune"), #imageLiteral(resourceName: "poisonImmune"), #imageLiteral(resourceName: "manaSlot"), #imageLiteral(resourceName: "manaChance")]
    @IBAction func abilityOrKizuna(_ sender: AnyObject) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            currentArray = abilityArray
        }
            
        else {
            currentArray = kizunaArray
        }
        defaults.setAbilityIndex(value: segmentedControl.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentedControl.selectedSegmentIndex = defaults.abilityIndex()
        
        currentArray = abilityArray
        tableView.reloadData()
        
        let backButton = UIBarButtonItem(title: "어빌", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableView.indexPathForSelectedRow != nil {
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "abilityArcana") {
            let vc = segue.destination as! AbilityView
            vc.selectedIndex = segmentedControl.selectedSegmentIndex
            vc.abilityType = currentArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            
        }
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

// MARK - UITableViewDelegate, UITableViewDataSource
extension AbilityList: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ability") as! AbilityCell
        cell.abilityName.text = currentArray[(indexPath as NSIndexPath).row]
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.abilityIcon.image = abilityImages[indexPath.row]
        }
        else {
            cell.abilityIcon.image = kizunaImages[indexPath.row]
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            //            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: -200, y: 0)
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)

        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            //        case 3:
        //            self.performSegue(withIdentifier: "showGrid", sender: (indexPath as NSIndexPath).row)
        default:
            self.performSegue(withIdentifier: "abilityArcana", sender: (indexPath as NSIndexPath).row)
        }
        
    }

}
