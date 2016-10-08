
//
//  TavernHomeView.swift
//  Chain
//
//  Created by Jitae Kim on 9/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Favorites: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var group = DispatchGroup()
    var array = [Arcana]()
    
    @IBAction func logout(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "잠깐!", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.view.tintColor = salmonColor
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            // Remove the user's uid from storage.
            UserDefaults.standard.setValue(nil, forKey: "uid")
            
            try! FIRAuth.auth()!.signOut()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            UIView.transition(with: self.view.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                    self.view.window!.rootViewController = initialViewController
                }, completion: nil)

//            self.view.window?.rootViewController = initialViewController
//            self.view.window?.makeKeyAndVisible()
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true) {
            alert.view.tintColor = salmonColor
        }
        
    }
    
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
        
        cell.imageSpinner.startAnimating()
        
        let arcana = array[indexPath.row]
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.nickNameKR {
            cell.arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.nickNameJP {
            
            cell.arcanaNickJP.text = nnJP
            
        }
        cell.arcanaNameKR.text = arcana.nameKR
        cell.arcanaNameJP.text = arcana.nameJP
        
        cell.arcanaRarity.text = "#\(arcana.rarity)★"
        cell.arcanaGroup.text = "#\(arcana.group)"
        cell.arcanaWeapon.text = "#\(arcana.weapon)"
        if let a = arcana.affiliation {
            if a != "" {
                cell.arcanaAffiliation.text = "#\(a)"
            }
            
        }
        
        cell.numberOfViews.text = "조회 \(arcana.numberOfViews)"
        cell.arcanaUID = arcana.uid
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg") {
            
            cell.arcanaImage.image = i
            cell.imageSpinner.stopAnimating()
            print("LOADED FROM CACHE")
            
        }
            
        else {
            
            STORAGE_REF.child("image/arcana/\(arcana.uid)/icon.jpg").downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    print("image download error")
                    
                    // Handle any errors
                } else {
                    // Get the download URL
                    let urlRequest = URLRequest(url: URL!)
                    DOWNLOADER.download(urlRequest) { response in
                        
                        if let image = response.result.value {
                            // Set the Image
                            
                            if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {
                                
                                // Cache the Image
                                IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/icon.jpg")
                                cell.imageSpinner.stopAnimating()
                                
                                if cell.arcanaUID == arcana.uid {
                                    cell.arcanaImage.image = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg")
                                    cell.arcanaImage.alpha = 0
                                    cell.arcanaImage.fadeIn()
                                }
                                
                                
                                print("DOWNLOADED")
                                
                                
                            }
                            else {
                                print("COULD NOT UNWRAP IMAGE")
                            }
                            
                            
                        }
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let arcanaDetail = storyBoard.instantiateViewController(withIdentifier: "ArcanaDetail") as! ArcanaDetail
        arcanaDetail.arcana = array[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
        self.navigationController?.pushViewController(arcanaDetail, animated: true)
        
    }
    
    func downloadFavorites() {
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

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadFavorites()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
