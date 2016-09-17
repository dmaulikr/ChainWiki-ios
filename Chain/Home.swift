
//  ViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
//import Toucan
import NVActivityIndicatorView

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filter: UIBarButtonItem!

    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    var searchArray = [Arcana]()
    let filterUpdate = Filter()
    var rarityArray = [String]()
    var gesture = UITapGestureRecognizer()
    var filters = [String: [String]]()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var filterView: UIView!
    
    @IBAction func sort(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = salmonColor
        alertController.setValue(NSAttributedString(string:
            "정렬", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")
        
        let alpha = UIAlertAction(title: "이름순", style: .default, handler: { (action:UIAlertAction) in
            self.arcanaArray = self.arcanaArray.sorted(by: {$0.nameKR < $1.nameKR})
            self.tableView.reloadData()
            
        })
        alertController.addAction(alpha)
        let recent = UIAlertAction(title: "최신순", style: .default, handler: { (action:UIAlertAction) in
            self.arcanaArray = self.originalArray
            self.tableView.reloadData()
            
        })
        
        alertController.addAction(recent)
        let views = UIAlertAction(title: "조회순", style: .default, handler: { (action:UIAlertAction) in
            let ref = FIREBASE_REF.child("arcana")
            ref.queryOrdered(byChild: "numberOfViews").observeSingleEvent(of: .value, with: { snapshot in
                
                var array = [Arcana]()
                for item in snapshot.children.reversed() {
                    
                    let arcana = Arcana(snapshot: item as! FIRDataSnapshot)
                    array.append(arcana!)
                }
                self.arcanaArray = array
                self.tableView.reloadData()
            })
            
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

    @IBAction func filter(_ sender: AnyObject) {
        
        if filterView.alpha == 0.0 {
            filterView.frame = CGRect(x: 95 , y: filterView.frame.origin.y, width: filterView.frame.width, height: filterView.frame.height)
            // TODO: if it was previously slided, make it appear in original position.
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.filterView.alpha = 1.0
                }, completion: nil)
            
        }
        else {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.filterView.alpha = 0.0
                }, completion: nil)
        }
    }

    func dismissFilter(_ sender: AnyObject) {
        
        if filterView.alpha == 1 && gesture.location(in: self.view).x < 95 {
            print("dismissed")
            gesture.cancelsTouchesInView = true
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.filterView.alpha = 0.0
                }, completion: nil)
        }
        else {
            gesture.cancelsTouchesInView = false
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showArcana", sender: (indexPath as NSIndexPath).row)
    }
    
    func downloadArray() {

        let ref = FIREBASE_REF.child("arcana")

        ref.queryLimited(toLast: 20).observe(.value, with: { snapshot in
            
            var filter = [Arcana]()
            for item in snapshot.children {
                let arcana = Arcana(snapshot: item as! FIRDataSnapshot)
                filter.append(arcana!)
            }
            self.arcanaArray = filter.reversed()
            self.originalArray = filter.reversed()
            self.tableView.reloadData()
        })
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return searchArray.count
        }
        
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        cell.arcanaImage.image = nil
        
        //let image = UIImage(named: "main.jpg")!
//        let image = Toucan(image: UIImage(named: "main.jpg")!).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//        cell.arcanaImage.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let c = cell as! ArcanaCell
        
        c.imageSpinner.startAnimating()
        
        let arcana: Arcana
        
        
        if searchController.isActive && searchController.searchBar.text != "" {
            arcana = searchArray[indexPath.row]
        } else {
            arcana = arcanaArray[indexPath.row]
        }
        
        
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.nickNameKR, let nnJP = arcana.nickNameJP {
            
            
            c.arcanaNickJP.text = nnJP
            c.arcanaNickKR.text = nnKR

//            let combinedNameKR = "\(nnKR) \(arcanaArray[indexPath.row].nameKR)"
//            c.arcanaNameKR.text = combinedNameKR
//            let combinedNameJP = "\(nnJP) \(arcanaArray[indexPath.row].nameJP)"
//            c.arcanaNameJP.text = combinedNameJP
        }
            c.arcanaNameKR.text = arcana.nameKR
            c.arcanaNameJP.text = arcana.nameJP
        
        c.arcanaRarity.text = "#\(arcana.rarity)★"
        c.arcanaGroup.text = "#\(arcana.group)"
        c.arcanaWeapon.text = "#\(arcana.weapon)"
        if let a = arcana.affiliation {
            c.arcanaAffiliation.text = "#\(a)"
        }
       
        c.arcanaImage.image = nil
        
        print("animated")
        
        // Check Cache, or download from Firebase
       // c.arcanaImage.image = UIImage(named: "main.jpg")
        //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
//        let image = Toucan(image: UIImage(named: "main.jpg")!).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//        cell.arcanaImage.image = image
        

        
        /*
        
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg") {
            
            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
//            let crop = Toucan(image: i).resize(c.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
            
//            let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
//            c.arcanaImage.image = crop
        }
         
            //  Not in cache, download from firebase
        else {
            c.imageSpinner.startAnimating()

            STORAGE_REF.child("image/arcana/\(arcana.uid)/icon.jpg").downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    print("image download error")
                    // Handle any errors
                } else {
                    // Get the download URL
                    print("DOWNLOAD URL = \(URL!)")
                    let urlRequest = URLRequest(url: URL!)
                    DOWNLOADER.download(urlRequest) { response in
                        
                        if let image = response.result.value {
                            // Set the Image
                            
                            // TODO: MAKE SMALL THUMBNAIL
                            
                            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)

                            
                            if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 1.0)!) {
                                c.imageSpinner.stopAnimating()

//                                let crop = Toucan(image: thumbnail).resize(c.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
//                                //let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
//                                c.arcanaImage.image = crop
                                
                                print("DOWNLOADED")
                                
                                // Cache the Image
                                IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/icon.jpg")
                            }

                            
                        }
                    }
                }
            }
            
        }
    */

    }
    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let a = childViewControllers[0] as? Filter {
            a.delegate = self
        }
        downloadArray()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        filterView.alpha = 0.0
        gesture = UITapGestureRecognizer(target: self, action: #selector(Home.dismissFilter(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Home.handlePanGesture(_:)))
        self.filterView.addGestureRecognizer(panGestureRecognizer)
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
        // UISearchController methods
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.setValue("취소", forKey:"_cancelButtonText")
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField, let searchIcon = searchTextField.leftView as? UIImageView {
            
            searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            searchIcon.tintColor = UIColor.white
            
            searchTextField.placeholder = "이름 검색"
            searchTextField.tintColor = UIColor.white
            searchTextField.setPlaceholderColor(UIColor.white)
            searchTextField.textColor = UIColor.white
            
        }

        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {

       // tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "showArcana") {
            let arcana: Arcana
            if searchController.isActive && searchController.searchBar.text != "" {
                arcana = searchArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            } else {
                arcana = arcanaArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            }
            let vc = segue.destination as! ArcanaDetail
            vc.arcana = arcana
            self.title = "이전"
        }
    }

    func didUpdate(_ sender: Filter) {
        DispatchQueue.main.async {
            
            if let vc = self.childViewControllers[0] as? Filter {
                
                self.filters = vc.filterTypes
                
                // No filters, bring back original array
                if vc.hasFilter == false {
                    // TODO: replace arcanaArray with original arcanaArray.
                        print("NO FILTERS, PREPARING ORIGINAL ARRAY")
                        self.arcanaArray = self.originalArray
                        self.tableView.reloadData()
                    
                    print("NO FILTERS")
                }
                    
                    
                else {  // hasFilter == true
                        // create set that combines all filters
                        //flatmap
                        
                        var raritySet = Set<Arcana>()
                        if let r = self.filters["rarity"] {
                            
                            for rarity in r {
                                print("FOR RARITY \(rarity)")
                                let filteredRarity = self.originalArray.filter({$0.rarity == rarity})
                                
                                raritySet = raritySet.union(Set(filteredRarity))
                            }
                            
                        }
                        
                        
                        var groupSet = Set<Arcana>()
                        if let g = self.filters["group"] {
                            
                            for group in g {
                                print(group)
                                let filteredGroup = self.originalArray.filter({$0.group == group})
                                groupSet = groupSet.union(Set(filteredGroup))
                            }
                            
                        }
                        
                        var weaponSet = Set<Arcana>()
                        if let w = self.filters["weapon"] {
                            
                            for weapon in w {
                                let filteredWeapon = self.originalArray.filter({$0.weapon[$0.weapon.startIndex] == weapon[weapon.startIndex]})
                                weaponSet = weaponSet.union(Set(filteredWeapon))
                            }
                            
                        }
                        
                        var affiliationSet = Set<Arcana>()
                        if let a = self.filters["affiliation"] {
                            
                            for affiliation in a {
                                let filteredAffiliation = self.originalArray.filter({$0.affiliation != nil && $0.affiliation!.contains(affiliation)})
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
                        self.arcanaArray = Array(finalFilter)
                        self.tableView.reloadData()
                        
                    
                    
                }
            }
            
            
            //            if let vc = self.childViewControllers[0] as? Home {
            //                vc.tableView.reloadData()
            //            }
        }
    }
    
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


    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchArray = originalArray.filter { arcana in
            return arcana.nameKR.contains(searchText) || arcana.nameJP.contains(searchText)
        }
        
        tableView.reloadData()
    }
    
}

extension Home: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}

