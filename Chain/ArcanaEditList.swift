//
//  ArcanaEditHistory.swift
//  Chain
//
//  Created by Jitae Kim on 10/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaEditList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tip: UILabel!
    var edits = [String]()
    var arcanaUID: String?
    var arcana: ArcanaEdit?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if edits.count == 0 {
            tableView.alpha = 0
            tip.alpha = 1
        }
        else {
            tableView.alpha = 1
            tip.alpha = 0
        }
        
        return edits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaEditListCell") as! ArcanaEditListCell
        cell.date.text = edits[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEdits", sender: self)
    }
    
    func getEdits() {
        // TODO: GET STRUCT ARCANAEDITS
        if let uid = arcanaUID {
            let ref = FIREBASE_REF.child("edits/\(uid)")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                var editDates = [String]()
                if let snapshotValue = snapshot.value as? NSDictionary {
                    
                    for child in (snapshotValue as? [String:AnyObject])!.reversed() {
                        
                        let date = child.value["date"] as! String
                        editDates.append(date)
                        let editUID = child.value["uid"] as! String
                        
                        let updateRef = ref.child("\(editUID)/update")
                        updateRef.observeSingleEvent(of: .value, with: { snapshot in
                            self.arcana = ArcanaEdit(snapshot: snapshot)
                        })
                        
                    }
                    self.edits = editDates
                    self.tableView.reloadData()
                }
                
            })
            
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArcanaEditListCell", bundle: nil), forCellReuseIdentifier: "arcanaEditListCell")
        getEdits()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEdits" {
            if let vc = segue.destination as? ArcanaDetailEdit {
                vc.arcanaEdit = arcana
            }
            print("going to showEdits")
        }
        
        
        
    }
 

}
