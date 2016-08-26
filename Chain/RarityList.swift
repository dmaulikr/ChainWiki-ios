//
//  Rarity.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RarityList: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var rarity: Int?
    let testArc = Arcana(n: "치도리", r: "5")
    var dict = [String: Arcana]()
    
    var dict1 = [Arcana]()
    
    var filteredArray = [Arcana]()
    
    func filterArray() {
        if let r = rarity {
            for (_,value) in dict {
                switch (r) {
                case 0: // Rarity 5
                    if (value.rarity! == "5") {
                        filteredArray.append(value)
                    }
//                case 1: // Rarity 4
//                case 2: // Rarity 3
//                case 3: // Rarity 2
//                case 4: // Rarity 1
                default: print("MAJOR ERROR, NO FILTERED ARRAY")
                }
            }
            
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dict.updateValue(testArc!, forKey: "OI")
        filterArray()
        
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("arcanaCell") as! ArcanaCell
        
        cell.name.text = filteredArray[indexPath.row].name
        return cell
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
