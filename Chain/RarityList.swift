//
//  Rarity.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class RarityList: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var rarityIndex: Int?
    //let testArc = Arcana(n: "치도리", r: "5")
    var dict = [String: Arcana]()
    
    //var dict1 = [Arcana]()
    
    var filteredArray = [Arcana]()
    var rarityArray = [String]()
    
    //let ref = FIREBASE_REF.child("")
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showArcana") {
            let vc = segue.destinationViewController as! ArcanaDetail
            vc.arcana = filteredArray[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showArcana", sender: indexPath.row)
    }
    
    func filterArray() {
        
        var rarity = ""
        
        if let r = rarityIndex {
            
            switch (r) {
            case 0: // Rarity 5
                rarity = "SSR"
            case 1: // Rarity 4
                rarity = "SR"
            case 2: // Rarity 3
                rarity = "R"
            case 3: // Rarity 2
                rarity = "HN"
            case 4: // Rarity 1
                rarity = "N"
            default: print("MAJOR ERROR, NO FILTERED ARRAY")
                rarity = "SSR"
            }
            
            print("RARITYREF = \(rarity)")
            let rarityRef = FIREBASE_REF.child("\(rarity)")
            rarityRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                //print(snapshot)
                for item in snapshot.children {
                    self.rarityArray.append(item.key)
                }
                
                
                let ref = FIREBASE_REF.child("arcana")
                
                for item in self.rarityArray {
                    //print(item)
                    ref.child("\(item)").observeEventType(.Value, withBlock: { snapshot in
                        print("snap \(snapshot)")
                        var filter = [Arcana]()
                        
                       // for a in snapshot {
                       //     print("a is \(a)")
                            let arcana = Arcana(snapshot: snapshot)
                            filter.append(arcana!)
                      //  }
                        
                        self.filteredArray = filter
                        self.tableView.reloadData()
                    })
                }
                
            })
            


            
            
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
