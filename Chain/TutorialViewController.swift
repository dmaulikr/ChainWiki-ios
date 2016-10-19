//
//  TutorialViewController.swift
//  Chain
//
//  Created by Jitae Kim on 10/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    public var tutorialIndex: Int!
    public var photo: UIImage!
    public var desc: String!

    @IBAction func startLogin(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "startLogin", sender: nil)
        
    }
    
    func setupButton() {
        let topBorder = UIView(frame: CGRect(x: 10, y: 0, width: SCREENWIDTH-20, height: 1))
        topBorder.backgroundColor = .lightGray
        startButton.addSubview(topBorder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = gray247Color
        setupButton()
        imageView.image = photo
        descLabel.text = desc
        pageControl.currentPage = tutorialIndex
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
