//
//  HomeContainerView.swift
//  Chain
//
//  Created by Jitae Kim on 9/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Canvas

class HomeContainerView: UIViewController, FilterDelegate {
    
    var filters = [String: [String]]()
    
    func didUpdate(sender: Filter) {
        dispatch_async(dispatch_get_main_queue()) {
            
            if let vc = self.childViewControllers[1] as? Filter {
                
                self.filters = vc.filterTypes
                
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
                        
                        // create set that combines all filters
                        //flatmap
                        
                        var raritySet = Set<Arcana>()
                        if let r = self.filters["rarity"] {
                            
                            for rarity in r {
                                print("FOR RARITY \(rarity)")
                                let filteredRarity = vc.originalArray.filter({$0.rarity == rarity})
                                
                                raritySet = raritySet.union(Set(filteredRarity))
                            }
                            
                        }
                        
                        
                        var groupSet = Set<Arcana>()
                        if let g = self.filters["group"] {
                            
                            for group in g {
                                print(group)
                                let filteredGroup = vc.originalArray.filter({$0.group == group})
                                groupSet = groupSet.union(Set(filteredGroup))
                            }
                            
                        }
                        
                        var weaponSet = Set<Arcana>()
                        if let w = self.filters["weapon"] {
                            
                            for weapon in w {
                                let filteredWeapon = vc.originalArray.filter({$0.weapon[$0.weapon.startIndex] == weapon[weapon.startIndex]})
                                weaponSet = weaponSet.union(Set(filteredWeapon))
                            }
                            
                        }
                        
                        var affiliationSet = Set<Arcana>()
                        if let a = self.filters["affiliation"] {
                            
                            for affiliation in a {
                                let filteredAffiliation = vc.originalArray.filter({$0.affiliation != nil && $0.affiliation!.containsString(affiliation)})
                                affiliationSet = affiliationSet.union(Set(filteredAffiliation))
                            }
                            
                        }
                        
                        let sets = ["rarity" : raritySet, "group" : groupSet, "weapon" : weaponSet, "affiliation" : affiliationSet]
                        
                        var finalFilter: Set = Set<Arcana>()
                        for (key,value) in sets {
                            
                            // TODO: clicking 권 then 철연 gives 철연.
                            if value.count != 0 {
                                
                                // if set is empty, create a new one
                                if finalFilter.count == 0 {
                                    finalFilter = finalFilter.union(value)
                                }
                                    
                                    // Set already exists, so intersect
                                else {
                                    finalFilter = finalFilter.intersect(value)
                                }
                            }
                        }
//                        for i in finalFilter {
//                            print(i)
//                        }
                        vc.arcanaArray = Array(finalFilter)
                        vc.tableView.reloadData()
                        
                    }
                    
                }
            }
            
            
//            if let vc = self.childViewControllers[0] as? Home {
//                vc.tableView.reloadData()
//            }
        }
    }
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var filterView: UIView!
    var array = [Arcana]()
    @IBAction func filter(sender: AnyObject) {
        
        if filterView.alpha == 0.0 {
            homeView.userInteractionEnabled = false
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.filterView.alpha = 1.0
                }, completion: nil)

        }
        else {
            homeView.userInteractionEnabled = true
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.filterView.alpha = 0.0
                }, completion: nil)
        }
    }

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? Filter {
            print("SEGUE DONE")
            destinationViewController.delegate = self
            destinationViewController.transitioningDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterView.alpha = 0.0
        
        // Do any additional setup after loading the view.
//        
//        if let vc = self.childViewControllers[0] as? Home {
//            vc.arcanaArray = vc.originalArray
//            vc.tableView.reloadData()
//            
//            
//        }
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

extension HomeContainerView: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
}