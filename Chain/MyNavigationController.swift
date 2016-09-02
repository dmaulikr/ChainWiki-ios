//
//  MyNavigationController.swift
//  Chain
//
//  Created by Jitae Kim on 9/2/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.navigationBar.barTintColor = UIColor.whiteColor()
        

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
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
