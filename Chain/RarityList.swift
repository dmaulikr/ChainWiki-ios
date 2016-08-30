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
    //let testArc = Arcana(n: "치도리", r: "5")
    var dict = [String: Arcana]()
    
    var dict1 = [Arcana]()
    
    var filteredArray = [Arcana]()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showArcana") {
            let vc = segue.destinationViewController as! ArcanaDetail
            vc.arcanaID = tableView.indexPathForSelectedRow!.row
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showArcana", sender: indexPath.row)
    }
    
    func filterArray() {
        if let r = rarity {
            for (_,value) in dict {
                switch (r) {
                case 0: // Rarity 5
                    if (value.rarity == "5") {
                        filteredArray.append(value)
                    }
                case 1: // Rarity 4
                    if (value.rarity == "4") {
                        filteredArray.append(value)
                    }
                case 2: // Rarity 3
                    if (value.rarity == "3") {
                        filteredArray.append(value)
                    }
                case 3: // Rarity 2
                    if (value.rarity == "2") {
                        filteredArray.append(value)
                    }
                case 4: // Rarity 1
                    if (value.rarity == "1") {
                        filteredArray.append(value)
                    }
                default: print("MAJOR ERROR, NO FILTERED ARRAY")
                }
            }
            
        }
        tableView.reloadData()
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("arcanaCell") as! ArcanaCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let c = cell as! ArcanaCell
//        guard let n = filteredArray[indexPath.row].name
//            else {
//                return
//            }
        c.name.text = filteredArray[indexPath.row].name

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
