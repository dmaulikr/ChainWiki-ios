//
//  HomeContainerView.swift
//  Chain
//
//  Created by Jitae Kim on 9/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Canvas
import Firebase

class HomeContainerView: UIViewController, FilterDelegate, UIGestureRecognizerDelegate {

//    func handleEdgePanGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
//        filterView.frame = CGRect(x: SCREENWIDTH , y: filterView.frame.origin.y, width: filterView.frame.width, height: filterView.frame.height)
//        filterView.alpha = 1
//        switch recognizer.state {
//        case .Began:
//            // move filterview to right of screen
//            
//            print("BEGAN")
//        case .Changed:
//            print("CHANGED")
//            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(filterView).x
//            recognizer.setTranslation(CGPointZero, inView: filterView)
//        default:
//            break
//        }
//    }
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
//        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch(recognizer.state) {
        case .began:
//            if self.filterView.alpha == 0 {
//                self.filterView.alpha = 1
//                self.filterView.frame = CGRect(x: SCREENWIDTH , y: filterView.frame.origin.y, width: filterView.frame.width, height: filterView.frame.height)
//            }
//            
            print("BEGAN")
        case .changed:
            
            if CGRect(x: 95, y: 0, width: self.view.frame.width, height: self.view.frame.height).contains(recognizer.location(in: self.view)) {
                // Gesture started inside the pannable view. Do your thing.
   
                if self.filterView.frame.origin.x >= 95 && recognizer.view!.frame.origin.x >= 95 {
                    if recognizer.view!.frame.origin.x >= 95 && recognizer.view!.frame.origin.x + recognizer.translation(in: filterView).x >= 95{
                            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: filterView).x
                            recognizer.setTranslation(CGPoint.zero, in: filterView)
                        
                    }
                }
                
                

            }
            

        case .ended:
            print("ENDED")
            // animate the side panel open or closed based on whether the view has moved more or less than halfway
            let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
            if recognizer.view!.frame.origin.x < 95 {
                recognizer.view!.frame.origin.x = 95
            }
            if hasMovedGreaterThanHalfway {
                //dismissFilter.
                print("HAS MOVED MORE THAN HALF, DISMISS")
                filter(self)
            }
            

        default:
            break
        }
    }
    
    var gesture = UITapGestureRecognizer()
    var filters = [String: [String]]()
    
    @IBAction func sort(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = salmonColor
        alertController.setValue(NSAttributedString(string:
            "정렬", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")

        let alpha = UIAlertAction(title: "이름순", style: .default, handler: { (action:UIAlertAction) in
            if let vc = self.childViewControllers[0] as? Home {
                vc.arcanaArray = vc.arcanaArray.sorted(by: {$0.nameKR < $1.nameKR})
                vc.tableView.reloadData()
            }
        })
        alertController.addAction(alpha)
        let recent = UIAlertAction(title: "최신순", style: .default, handler: { (action:UIAlertAction) in
            if let vc = self.childViewControllers[0] as? Home {
                vc.arcanaArray = vc.originalArray
                vc.tableView.reloadData()
            }
        })

        alertController.addAction(recent)
        let views = UIAlertAction(title: "조회순", style: .default, handler: { (action:UIAlertAction) in
            if let vc = self.childViewControllers[0] as? Home {
                let ref = FIREBASE_REF.child("arcana")
                ref.queryOrdered(byChild: "numberOfViews").observeSingleEvent(of: .value, with: { snapshot in
                    
                    var array = [Arcana]()
                    for item in snapshot.children.reversed() {
                        
                        let arcana = Arcana(snapshot: item as! FIRDataSnapshot)
                        array.append(arcana!)
                    }
                    vc.arcanaArray = array
                    vc.tableView.reloadData()
                })
            }
        })

        alertController.addAction(views)
        let viewed = UIAlertAction(title: "최근본순", style: .default, handler: nil)
        alertController.addAction(viewed)
        alertController.addAction(UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = salmonColor
        })
    }
    func didUpdate(_ sender: Filter) {
        DispatchQueue.main.async {
            
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
                                let filteredAffiliation = vc.originalArray.filter({$0.affiliation != nil && $0.affiliation!.contains(affiliation)})
                                affiliationSet = affiliationSet.union(Set(filteredAffiliation))
                            }
                            
                        }
                        
                        let sets = ["rarity" : raritySet, "group" : groupSet, "weapon" : weaponSet, "affiliation" : affiliationSet]
                        
                        var finalFilter: Set = Set<Arcana>()
                        for (_,value) in sets {
                            
                            // TODO: clicking 권 then 철연 gives 철연.
                            if value.count != 0 {
                                
                                // if set is empty, create a new one
                                if finalFilter.count == 0 {
                                    finalFilter = finalFilter.union(value)
                                }
                                    
                                    // Set already exists, so intersect
                                else {
                                    finalFilter = finalFilter.intersection(value)
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
    @IBAction func filter(_ sender: AnyObject) {
        
        if filterView.alpha == 0.0 {
            filterView.frame = CGRect(x: 95 , y: filterView.frame.origin.y, width: filterView.frame.width, height: filterView.frame.height)
            // TODO: if it was previously slided, make it appear in original position.
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.filterView.alpha = 1.0
                }, completion: nil)

        }
        else {
//            homeView.userInteractionEnabled = true
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.filterView.alpha = 0.0
                }, completion: nil)
        }
    }

    
    
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationViewController = segue.destination as? Filter {
//            print("SEGUE DONE")
//            destinationViewController.delegate = self
//            destinationViewController.transitioningDelegate = self
//        }
//    }
//    
    func dismissFilter(_ sender: AnyObject) {
        print("dismissed")
        if filterView.alpha == 1 {
            gesture.cancelsTouchesInView = true
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.filterView.alpha = 0.0
                }, completion: nil)
        }
        else {
            gesture.cancelsTouchesInView = false
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterView.alpha = 0.0
        gesture = UITapGestureRecognizer(target: self, action: #selector(HomeContainerView.dismissFilter(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeContainerView.handlePanGesture(_:)))
        self.filterView.addGestureRecognizer(panGestureRecognizer)
        gesture.cancelsTouchesInView = false
        homeView.addGestureRecognizer(gesture)
        
//        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePanGesture:")
//        edgePanGestureRecognizer.edges = .Right
//        self.view.addGestureRecognizer(edgePanGestureRecognizer)
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
//
//extension HomeContainerView: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return PresentMenuAnimator()
//    }
//}
