//
//  SearchHistory.swift
//  Chain
//
//  Created by Jitae Kim on 9/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SearchHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var history = [String]()
    var arcanaArray = [Arcana]()
    var group = DispatchGroup()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaTextCell") as! ArcanaTextCell
        
        cell.nameKR.text = arcanaArray[indexPath.row].nameKR
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "searchToArcana", sender: (indexPath as NSIndexPath).row)
    }
    
    
    func updateSearches() {
        let uids = defaults.object(forKey: "recent") as? [String] ?? [String]().reversed()
        // todo. if i crash here, set some bool to true to check at next open and clear defaults.
//        defaults.removeObject(forKey: "recent")
        if uids.count > 0 {
            var array = [Arcana]()
            
            for id in uids {
                group.enter()
                
                let ref = FIREBASE_REF.child("arcana/\(id)")
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                        
                    }
                    self.group.leave()
                    
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.arcanaArray = array.reversed()
                self.tableView.reloadData()
            })
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArcanaTextCell", bundle: nil), forCellReuseIdentifier: "arcanaTextCell")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearches()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "searchToArcana") {
            let arcana: Arcana

            arcana = arcanaArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]

            let vc = segue.destination as! ArcanaDetail
            vc.arcana = arcana
        }
    }

}
