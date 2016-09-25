//
//  TavernHomeView.swift
//  Chain
//
//  Created by Jitae Kim on 9/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class Favorites: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var group = DispatchGroup()
    
    var array = [Arcana]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if array.count == 0 {
            tableView.alpha = 0
        }
        else {
            tableView.alpha = 1
        }
        
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        
        let arcana: Arcana
        arcana = array[indexPath.row]
        
        if let nnKR = arcana.nickNameKR, let nnJP = arcana.nickNameJP {
            
            
            cell.arcanaNickJP.text = nnJP
            cell.arcanaNickKR.text = nnKR
            
            //            let combinedNameKR = "\(nnKR) \(arcanaArray[indexPath.row].nameKR)"
            //            c.arcanaNameKR.text = combinedNameKR
            //            let combinedNameJP = "\(nnJP) \(arcanaArray[indexPath.row].nameJP)"
            //            c.arcanaNameJP.text = combinedNameJP
        }
        cell.arcanaNameKR.text = arcana.nameKR
        cell.arcanaNameJP.text = arcana.nameJP
        
        cell.arcanaRarity.text = "#\(arcana.rarity)★"
        cell.arcanaGroup.text = "#\(arcana.group)"
        cell.arcanaWeapon.text = "#\(arcana.weapon)"
        if let a = arcana.affiliation {
            cell.arcanaAffiliation.text = "#\(a)"
        }
        
        cell.numberOfViews.text = "조회 \(arcana.numberOfViews)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let arcanaDetail = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        arcanaDetail.arcana = array[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        self.navigationController?.pushViewController(arcanaDetail, animated: true)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let uid = USERID {
            let ref = FIREBASE_REF.child("user/\(uid)/favorites")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                var uid = [String]()
                
                for child in snapshot.children {
                    let arcanaID = (child as AnyObject).key as String
                    uid.append(arcanaID)
                }
                
                
                var array = [Arcana]()
                
                for id in uid {
                    self.group.enter()
                    
                    let ref = FIREBASE_REF.child("arcana/\(id)")
                    
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        let arcana = Arcana(snapshot: snapshot)
                        array.append(arcana!)
                        self.group.leave()
                        
                    })
                }
                
                self.group.notify(queue: DispatchQueue.main, execute: {
                    self.array = array
                    self.tableView.reloadData()
                })
                
                
            })

        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
