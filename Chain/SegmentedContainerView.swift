//
//  SegmentedContainerView.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

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
                
                if vc.filterTypes.count == 0 {
                    print("NO FILTERS")
                }
                
                else {
                    filteredArray = arcanaArray.filter({$0.rarity == "★★★★★SSR"})
                    for i in filteredArray {
                        print(i.nameKR)
                    }
                    if let vc = self.childViewControllers[0] as? Home {
                        print("BACK TO HOME")
                        vc.arcanaArray = filteredArray
                        vc.tableView.reloadData()
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
