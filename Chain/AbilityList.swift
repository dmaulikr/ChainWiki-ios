//
//  ArcanaAbilityDB.swift
//  Chain
//
//  Created by Jitae Kim on 8/30/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.tintColor = UIColor.white
        }
    }
    
    let arcanaArray = [Arcana]()
    var currentArray = [String]()
    // TODO. remember user's last preference.
    let abilityArray = ["마나의 소양", "상자 획득", "AP 회복", "골드", "경험치", "서브시 증가", "마나 슬롯 속도", "마나 획득 확률 증가"]
    let kizunaArray = ["마나의 소양", "상자 획득", "AP 회복", "골드", "경험치", "서브시 증가", "필살기 증가", "공격력 증가", "보스 웨이브시 공격력 증가", "어둠 면역", "슬로우 면역", "독 면역", "마나 슬롯 속도", "마나 획득 확률 증가"]
    
    
    @IBAction func abilityOrKizuna(_ sender: AnyObject) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            currentArray = abilityArray
        }
            
        else {
            currentArray = kizunaArray
        }
        tableView.reloadData()
    }
    
    
    
    //TODO: Make tab bar controller control the original array, and load this for each view
    
    
    
    
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
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        switch indexPath.row {
//        case 0:
            self.performSegue(withIdentifier: "showMana", sender: (indexPath as NSIndexPath).row)
//        default:
//            break
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        segmentedControl.selectedSegmentIndex = 0
        currentArray = abilityArray
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMana") {
            let vc = segue.destination as! ManaAbility
            vc.selectedIndex = segmentedControl.selectedSegmentIndex
            vc.abilityType = currentArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            
        }
        self.title = "이전"
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
