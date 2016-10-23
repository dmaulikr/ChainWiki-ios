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
    var names = [String]()
    var arcanaUID: String?
    var arcanaEdit = [ArcanaEdit]()
    var editor: String?
    var arcanaEditModel = [ArcanaEditModel]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arcanaEditModel.count == 0 {
            tableView.alpha = 0
            tip.alpha = 1
        }
        else {
            tableView.alpha = 1
            tip.alpha = 0
        }
        print(arcanaEditModel.count)
        
        return arcanaEditModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaEditListCell") as! ArcanaEditListCell
        
        cell.date.text = arcanaEditModel[indexPath.row].date
        cell.name.text = arcanaEditModel[indexPath.row].editorName
//        cell.date.text = edits[indexPath.row]
//        cell.name.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEdits", sender: self)
    }
    
    func getEdits() {
        // TODO: GET STRUCT ARCANAEDITS
        if let uid = arcanaUID {
            let ref = FIREBASE_REF.child("arcanaEdit/\(uid)")
            ref.observeSingleEvent(of: .value, with: { snapshot in
//                
//                var editDates = [String]()
//                var editNames = [String]()
                if let snapshotValue = snapshot.value as? NSDictionary {
                    
                    for child in (snapshotValue as? [String:AnyObject])!.reversed() {
                        
                        let date = child.value["date"] as! String
//                        editDates.append(date)
                        let name = child.value["nickName"] as! String
//                        editNames.append(name)
                        let editUID = child.value["uid"] as! String
//                        self.editor = editUID
                        let updateRef = ref.child("\(editUID)/update")
                        updateRef.observeSingleEvent(of: .value, with: { snapshot in
                            var indexes = [IndexPath]()
                            if let arcana = ArcanaEdit(snapshot: snapshot) {
                                self.arcanaEditModel.insert(ArcanaEditModel(a: arcana, id: editUID, name: name, ref: ref.child(child.key), d: date), at: 0)
                                indexes.append(IndexPath(row: 0, section: 0))
                            }
                            
                            
                            self.tableView.insertRows(at: indexes, with: UITableViewRowAnimation.automatic)
                        })
                        
                    }
                    
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
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
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
            if let vc = segue.destination as? ArcanaEditHistory {
                vc.arcana = arcanaEditModel[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
                vc.editor = editor
                
            }
            print("going to showEdits")
        }
        
        
        
    }
 

}
