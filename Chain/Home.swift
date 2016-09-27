
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

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterDelegate, UIGestureRecognizerDelegate, TavernViewDelegate, UISearchControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var initialLoad = true
    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    var searchArray = [Arcana]()
    let filterUpdate = Filter()
    var rarityArray = [String]()
    var gesture = UITapGestureRecognizer()
    var filters = [String: [String]]()
    let searchController = UISearchController(searchResultsController: nil)
    var showNavBar = true
    var navTitle = ""
    var downloadTavern = false
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    func setupBarButtons() {
        
        let filter = UIButton()
        filter.setImage(UIImage(named: "filter.png"), for: .normal)
        filter.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filter.addTarget(self, action: #selector(Home.filter(_:)), for: .touchUpInside)
        let filterButton = UIBarButtonItem()
        filterButton.customView = filter
        
        let sort = UIButton()
        sort.setImage(UIImage(named: "sort.png"), for: .normal)
        sort.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        sort.addTarget(self, action: #selector(Home.sort(_:)), for: .touchUpInside)
        let sortButton = UIBarButtonItem()
        sortButton.customView = sort
 
        self.navigationItem.rightBarButtonItems = [filterButton,sortButton]
    }
    
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
            
            let ref = FIREBASE_REF.child("arcana")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                var array = [Arcana]()
                for item in snapshot.children.reversed() {
                    
                    if let arcana = Arcana(snapshot: item as! FIRDataSnapshot) {
                        array.append(arcana)
                    }
                    
                }
                self.arcanaArray = array
                self.tableView.reloadData()
            })

        })
        
        alertController.addAction(recent)
        let views = UIAlertAction(title: "조회순", style: .default, handler: { (action:UIAlertAction) in
            let ref = FIREBASE_REF.child("arcana")
            ref.queryOrdered(byChild: "numberOfViews").observeSingleEvent(of: .value, with: { snapshot in
                
                var array = [Arcana]()
                for item in snapshot.children.reversed() {
                    
                    if let arcana = Arcana(snapshot: item as! FIRDataSnapshot) {
                        array.append(arcana)
                    }
                }
                self.arcanaArray = array
                self.tableView.reloadData()
            })
            
        })
        
        alertController.addAction(views)
        
//        let viewed = UIAlertAction(title: "최근본순", style: .default, handler: nil)
//        alertController.addAction(viewed)
//        alertController.addAction(UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {
//            (alertAction: UIAlertAction!) in
//            alertController.dismiss(animated: true, completion: nil)
//        }))
        
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
        
        if searchView.alpha == 1 && gesture.location(in: self.view).y > 220 {
            print("alpha is 1 and gesture != searchview")
            gesture.cancelsTouchesInView = true
            searchController.dismiss(animated: true, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.searchView.alpha = 0.0
                }, completion: nil)
            
            
        }
        
        else if filterView.alpha == 1 && gesture.location(in: self.view).x < 95 {
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
    
    func syncArcana() {

        let ref = FIREBASE_REF.child("arcana")
        
        ref.observe(.childAdded, with: { snapshot in

            if let arcana = Arcana(snapshot: snapshot) {
//                self.arcanaArray.append(arcana)
                self.originalArray.append(arcana)
                
                if self.initialLoad == false { //upon first load, don't reload the tableView until all children are loaded
                    self.tableView.reloadData()
                }
                print("child added")
            }
            
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print("inital data loaded so reload tableView!  \(snapshot.childrenCount)")
            self.arcanaArray = self.originalArray.reversed()
            self.tableView.reloadData()
            self.initialLoad = false
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            print(snapshot.key)
            let uidToRemove = snapshot.key
            
            for (index, arcana) in self.originalArray.enumerated() {
                if arcana.uid == uidToRemove {
                    self.originalArray.remove(at: index)
                    
                }
                
            }
            
            for (index, arcana) in self.arcanaArray.enumerated() {
                if arcana.uid == uidToRemove {
                    self.arcanaArray.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
            }
        })
        
        ref.observe(.childChanged, with: { snapshot in
            
            let uidToChange = snapshot.key
        
            print("THE ATTRIBUTE THAT WAS CHANGED IS \(snapshot.value)")
            
            if let index = self.originalArray.index(where: {$0.uid == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.originalArray[index] = arcana
                }
                
            }
            
            
            if let index = self.arcanaArray.index(where: {$0.uid == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.arcanaArray[index] = arcana
                    self.tableView.reloadData()
                }
                
            }

        })
    }
    
    func getFavorites() {
        
        let userFavorites = FIREBASE_REF.child("user/\(USERID!)/favorites")
        
        userFavorites.observeSingleEvent(of: .value, with: { snapshot in
            
            var favorites = [Arcana]()
            for item in snapshot.children {
                if let arcana = Arcana(snapshot: item as! FIRDataSnapshot) {
                    favorites.append(arcana)
                }
            }
            self.arcanaArray = favorites
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arcanaArray.count == 0 {
            tableView.alpha = 0
        }
        else {
            tableView.alpha = 1
        }
        if searchController.isActive && searchController.searchBar.text != "" {

            if searchArray.count == 0 {
                tableView.alpha = 0
            }
            else {
                tableView.alpha = 1
            }
            
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
        
        cell.imageSpinner.startAnimating()
        
        let arcana: Arcana
        
        
        if searchController.isActive && searchController.searchBar.text?.isEmpty == false {
            arcana = searchArray[indexPath.row]
        } else {
            arcana = arcanaArray[indexPath.row]
        }
        

        // check if arcana has only name, or nickname.
        if let nnKR = arcana.nickNameKR, let nnJP = arcana.nickNameJP {
            
            
            cell.arcanaNickJP.text = nnJP
            cell.arcanaNickKR.text = nnKR
            
            //            let combinedNameKR = "\(nnKR) \(arcanaArray[indexPath.row].nameKR)"
            //            cell.arcanaNameKR.text = combinedNameKR
            //            let combinedNameJP = "\(nnJP) \(arcanaArray[indexPath.row].nameJP)"
            //            cell.arcanaNameJP.text = combinedNameJP
        }
        cell.arcanaNameKR.text = arcana.nameKR
        cell.arcanaNameJP.text = arcana.nameJP
        
        cell.arcanaRarity.text = "#\(arcana.rarity)★"
        cell.arcanaGroup.text = "#\(arcana.group)"
        cell.arcanaWeapon.text = "#\(arcana.weapon)"
        if let a = arcana.affiliation {
            cell.arcanaAffiliation.text = "#\(a)"
        }
        
        cell.numberOfViews.text = "조회 \(arcana.numberOfViews)"
        
        cell.arcanaImage.image = nil
        
        
        // Check Cache, or download from Firebase
        // cell.arcanaImage.image = UIImage(named: "main.jpg")
        //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
        //        let image = Toucan(image: UIImage(named: "main.jpg")!).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
        //        cell.arcanaImage.image = image
        
        
        
        
        
        // Check cache first
        if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg") {
            
            //let size = CGSize(width: SCREENHEIGHT/8, height: SCREENHEIGHT/8)
            //            let crop = Toucan(image: i).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
            
            //            let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
            //            cell.arcanaImage.image = crop
            cell.arcanaImage.image = i
            cell.imageSpinner.stopAnimating()
            
        }
            
            //  Not in cache, download from firebase
        else {
            //            cell.imageSpinner.startAnimating()
            
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
                                
                                
                                //                                let crop = Toucan(image: thumbnail).resize(cell.arcanaImage.frame.size, fitMode: Toucan.Resize.FitMode.Crop).image
                                //                                //let maskedCrop = Toucan(image: crop).maskWithRoundedRect(cornerRadius: 5, borderWidth: 3, borderColor: borderColor).image
                                //                                cell.arcanaImage.image = crop
                                //                                let rect = CGRect(x: 0, y: 0, width: thumbnail.size.width, height: thumbnail.size.width)
                                //                                let imageRef = thumbnail.cgImage?.cropping(to: rect)
                                //                                let image = UIImage(cgImage: imageRef!, scale: 1.0, orientation: .up)
                                //                                cell.arcanaImage.image = image
                                cell.arcanaImage.image = thumbnail
                                print("DOWNLOADED")
                                
                                cell.imageSpinner.stopAnimating()
                                
                                // Cache the Image
                                IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/icon.jpg")
                            }
                            
                            
                        }
                    }
                }
            }
            
        }

        
        
        return cell
    }

    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtons()
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        if let a = childViewControllers[0] as? Filter {
            a.delegate = self
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        syncArcana()

        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        searchView.alpha = 0
        filterView.alpha = 0.0
        gesture = UITapGestureRecognizer(target: self, action: #selector(Home.dismissFilter(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Home.handlePanGesture(_:)))
//        self.filterView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
//        self.view.addGestureRecognizer(panGestureRecognizer)
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(panGestureRecognizer)
        // UISearchController methods
        
        if showNavBar {
            print("TRUE")
            
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.searchBarStyle = .minimal
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.delegate = self
//            searchController.searchBar.endEditing(true)
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
        
        else {
            self.navigationItem.title = navTitle
            self.navigationItem.rightBarButtonItems = nil
        }
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        tableView.reloadData()
//    }
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
    
    func didUpdate(_ sender: TavernView, tavern: String) {
        
        
        DispatchQueue.main.async {
            
            let ref = FIREBASE_REF.child("tavern/\(tavern)")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                var tavern = [Arcana]()
                for item in snapshot.children {
                    if let arcana = Arcana(snapshot: item as! FIRDataSnapshot) {
                        tavern.append(arcana)
                    }
                }
                self.arcanaArray = tavern
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
                
            })
            
        }
        
        
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("in shouldReceiveTouch")
//        gestureRecognizer.delegate = self
//        if filterView.alpha == 1 {
//            print("touching filterview")
//            return true
//        }
//        else if CGRect(x: self.view.frame.width - 50, y: 0, width: self.view.frame.width, height: self.view.frame.height).contains(touch.location(in: self.view)) {
//            print("should open filterview")
//            return true
//        }
//        else {
//            
//            return false
//        }
//    }
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        //        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
//        if filterView.alpha == 1 && recognizer.view == self.filterView {
//            print("touching filterview")
//            
////            recognizer.isEnabled = false
//        }
//        else {
//            recognizer.isEnabled = false
//        }
        switch(recognizer.state) {
        case .began:
//            if filterView.alpha == 0 && recognizer.view == self.view {
//                recognizer.isEnabled = false
//            }
        
            //            if self.filterView.alpha == 0 {
            //                self.filterView.alpha = 1
            //                self.filterView.frame = CGRect(x: SCREENWIDTH , y: filterView.frame.origin.y, width: filterView.frame.width, height: filterView.frame.height)
            //            }
            //
            
            print("BEGAN")
        case .changed:
            
//            if filterView.alpha == 0 && recognizer.view == self.view {
//                print("should open filter")
//                recognizer.isEnabled = false
//            } else
            if CGRect(x: 95, y: 0, width: self.view.frame.width, height: self.view.frame.height).contains(recognizer.location(in: self.view)) {
                // Gesture started inside the pannable view. Do your thing.
                print("Filter is opened, move it")
                if self.filterView.frame.origin.x >= 95 && recognizer.view!.frame.origin.x >= 95 {
                    if recognizer.view!.frame.origin.x >= 95 && recognizer.view!.frame.origin.x + recognizer.translation(in: filterView).x >= 95{
                        recognizer.view!.subviews[0].center.x = recognizer.view!.subviews[0].center.x + recognizer.translation(in: filterView).x
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
            recognizer.isEnabled = true
            
        default:
            break
        }
        recognizer.isEnabled = true
    }


    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        // dismiss history if user starts typing.
        if searchText != "" {
            searchView.alpha = 0
        }
        
        searchArray = originalArray.filter { arcana in
            return arcana.nameKR.contains(searchText) || arcana.nameJP.contains(searchText)
        }
        
        tableView.reloadData()
    }
    

    func didPresentSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.searchView.alpha = 1.0
                }, completion: nil)
    }
    

    func didDismissSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.searchView.alpha = 0.0
            }, completion: nil)
        
    }


}

extension Home: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    
}

