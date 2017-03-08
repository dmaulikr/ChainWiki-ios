//
//  TavernHomeView.swift
//  Chain
//
//  Created by Jitae Kim on 9/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class TavernHomeView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tavern = ""
    var navTitle = ""
    var group = DispatchGroup()

    var array = [Arcana]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        self.title = navTitle
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let ref = FIREBASE_REF.child("tavern/\(tavern)")
        
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
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                    }
                    
                    self.group.leave()
                    
                })
            }
            
            self.group.notify(queue: DispatchQueue.main, execute: {
                print("Finished all requests.")
                self.array = array.sorted { $0.getRarity() > $1.getRarity() }
                self.tableView.reloadData()
            })
            
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: row, animated: true)
        }
    }
}

// MARK - UITableViewDelegate, UITableViewDataSource
extension TavernHomeView: UITableViewDelegate, UITableViewDataSource {
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
        
        for i in cell.labelCollection {
            i.text = nil
        }
        cell.arcanaImage.image = nil
        
        //        cell.imageSpinner.startAnimating()
        
        let arcana = array[indexPath.row]
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.getNicknameKR() {
            cell.arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.getNicknameJP() {
            
            cell.arcanaNickJP.text = nnJP
            
        }
        cell.arcanaNameKR.text = arcana.getNameKR()
        cell.arcanaNameJP.text = arcana.getNameJP()
        
        cell.arcanaRarity.text = "#\(arcana.getRarity())★"
        cell.arcanaGroup.text = "#\(arcana.getGroup())"
        cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
        if let a = arcana.getAffiliation() {
            if a != "" {
                cell.arcanaAffiliation.text = "#\(a)"
            }
            
        }
        
        cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
        cell.arcanaUID = arcana.getUID()
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/icon.jpg") {
            
            cell.arcanaImage.image = i
            //            cell.imageSpinner.stopAnimating()
            print("LOADED FROM CACHE")
            
        }
            
        else {
            FirebaseService.dataRequest.downloadImage(uid: arcana.uid, sender: cell)
        }
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let arcanaDetail = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        arcanaDetail.arcana = array[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        self.navigationController?.pushViewController(arcanaDetail, animated: true)
        
    }

}
