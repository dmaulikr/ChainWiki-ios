//
//  SegmentedContainerView.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SegmentedContainerView: UIViewController {

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
        case 1:
            arcanaView.hidden = true
            filterView.hidden = false
        default:
            break;
        }
    }
    
    @IBOutlet weak var arcanaView: UIView!
    @IBOutlet weak var filterView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        segmentedControl.selectedSegmentIndex = 0
        arcanaView.hidden = false
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
