//
//  HomeContainerView.swift
//  Chain
//
//  Created by Jitae Kim on 9/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class HomeContainerView: UIViewController {

    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBAction func filter(sender: AnyObject) {
//        if filterView.alpha == 0.0 {
//            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                self.filterView.alpha = 1.0
//                }, completion: nil)
//
//        }
//        else {
//            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//                self.filterView.alpha = 0.0
//                }, completion: nil)
//        }
        performSegueWithIdentifier("openMenu", sender: nil)

    }
    
    
    @IBAction func openMenu(sender: AnyObject) {
        performSegueWithIdentifier("openMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? Filter {
            destinationViewController.transitioningDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterView.alpha = 0.0
        // Do any additional setup after loading the view.
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