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

    func didUpdate(sender: Filter) {
        dispatch_async(dispatch_get_main_queue()) {
            if let vc = self.childViewControllers[0] as? Home {
                vc.tableView.reloadData()
            }
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