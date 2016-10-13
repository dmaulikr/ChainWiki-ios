//
//  ArcanaEditHistory.swift
//  Chain
//
//  Created by Jitae Kim on 10/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaEditList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let edits = [String]()
    var arcanaUID: String?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if edits.count == 0 {
            tableView.alpha = 0
        }
        else {
            tableView.alpha = 1
        }
        
        return edits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaEditListCell") as! ArcanaEditListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func getEdits() {
        // TODO: GET STRUCT ARCANAEDITS
        print("GETTING EDITS")
        if let uid = arcanaUID {
            let ref = FIREBASE_REF.child("edits/\(uid)")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                var editDates = [String]()
                if let snapshotValue = snapshot.value as? NSDictionary {
                    print("snapshotvalue")
                    for child in (snapshotValue as? [String:AnyObject])! {
                        print("child") 
                        let date = child.value["date"] as! String 
                            print(date)
                        
                        
                        
                    }
                }
                else {
                    print("ERROR")
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
        
        
        
    }
 

}
