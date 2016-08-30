//
//  ViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Kanna
import Firebase

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var dict = [String: Arcana]()
    
    
    var filteredArray = [Arcana]()
    var recentArray = [String]()
    
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
        
        let recentRef = FIREBASE_REF.child("arcana")
        
        let recentQuery = recentRef.queryLimitedToFirst(10).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            var filter = [Arcana]()
            
            for item in snapshot.children {
                let arcana = Arcana(snapshot: snapshot)
                filter.append(arcana!)
            }

            self.filteredArray = filter
            self.tableView.reloadData()
        
            })
        
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


