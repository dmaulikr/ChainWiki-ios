//
//  SegmentedContainerView.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class SegmentedContainerView: UIViewController {

    var arcanaArray = [Arcana]()
    var filteredArray = [Arcana]()
    var filters = [String: [String]]()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.tintColor = salmonColor
        }
    }
    
    
    @IBAction func segmentedControl(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            arcanaView.hidden = false
            filterView.hidden = true
            if let vc = self.childViewControllers[1] as? Filter {
                
                filters = vc.filterTypes
                
                if vc.hasFilter == false {
                    // TODO: replace arcanaArray with original arcanaArray.
                    if let vc = self.childViewControllers[0] as? Home {
                        print("NO FILTERS, PREPARING ORIGINAL ARRAY")
                        vc.arcanaArray = vc.originalArray
                        vc.tableView.reloadData()
                    }
                    print("NO FILTERS")
                }
                
                else {  // hasFilter == true
                    if let vc = self.childViewControllers[0] as? Home {
                        
                        var rarityArray = [Arcana]()
                        if let r = filters["rarity"] {
                            
                            for rarity in r {
                                for arcana in vc.originalArray {
                                    if arcana.rarity == rarity {
                                        
                                        rarityArray.append(arcana)
                                    }
                                }
                                vc.arcanaArray = rarityArray
                                vc.tableView.reloadData()
                            }
                        
                        }
                        
                        var groupArray = [Arcana]()
                        if let g = filters["group"] {
                            
                            for group in g {
                                let filteredGroup = vc.originalArray.filter({$0.group == group})
                                groupArray += filteredGroup
                            }
                            vc.arcanaArray = groupArray
                            vc.tableView.reloadData()
                            
                        }
                        
                        var weaponArray = [Arcana]()
                        if let w = filters["weapon"] {
                            
                            for weapon in w {
                                let filteredWeapon = vc.originalArray.filter({$0.weapon[$0.weapon.startIndex] == weapon[weapon.startIndex]})
                                weaponArray += filteredWeapon
                            }
                            vc.arcanaArray = weaponArray
                            vc.tableView.reloadData()
                            
                        }
                        
                        var affiliationArray = [Arcana]()
                        if let a = filters["affiliation"] {
                            
                            for affiliation in a {
                                let filteredAffiliation = vc.originalArray.filter({$0.affiliation.containsString(affiliation)})
                                affiliationArray += filteredAffiliation
                            }
                            vc.arcanaArray = affiliationArray
                            vc.tableView.reloadData()
                            
                        }
                        
                        
                    }

                }
            }
            
//            arcanaLoop: for arcana in arcanaArray {
            

                //filteredArray = arcanaArray( {0["rarity"] == "★★★★★SSR"})
                
//                for weapon in filters["weapon"]! {
//                    if arcana.weapon == weapon {
//                        filteredArray.append(arcana)
//                        break arcanaLoop
//                    }
//                }
//
//                for affiliation in filters["affiliation"]! {
//                    if arcana.affiliation == affiliation {
//                        filteredArray.append(arcana)
//                        break arcanaLoop
//                    }
//                }

//            }
            // TODO: get filters from Filter, and filter array before switching.
        case 1:
            arcanaView.hidden = true
            filterView.hidden = false
        default:
            break;
        }
    }
    
    func filter(string: String) {
//        switch string {
//            case "rarity":
//                for rarity in filters["rarity"]! {
//                    if arcana.rarity == rarity {
//                        filteredArray.append(arcana)
//                        break arcanaLoop
//                    }
//            }
//            case "group":
//            case "weapon":
//        default:
//        }
//        for attribute in filters["\(string)"]! {
//            if arcana.rarity == rarity {
//                filteredArray.append(arcana)
//                break arcanaLoop
//            }
//        }

    }
    
    @IBOutlet weak var arcanaView: UIView!
    @IBOutlet weak var filterView: UIView!

    
    func getArray() {
        
        let ref = FIREBASE_REF.child("arcana")
        
        ref.queryLimitedToLast(20).observeEventType(.Value, withBlock: { snapshot in
            
            var filter = [Arcana]()
            for item in snapshot.children {
                let arcana = Arcana(snapshot: item as! FIRDataSnapshot)
                filter.append(arcana!)
            }

            if let vc = self.childViewControllers[0] as? Home {
                //print("BACK TO HOME")
                vc.arcanaArray = filter
                vc.originalArray = filter
                self.arcanaArray = filter
                vc.tableView.reloadData()
            }
            
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArray()
        
        segmentedControl.selectedSegmentIndex = 0
        arcanaView.hidden = false
        filterView.hidden = true
//        if let n = navigationController {
//            n.navigationBar.barTintColor = lightNavyColor
//            
//        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {

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
