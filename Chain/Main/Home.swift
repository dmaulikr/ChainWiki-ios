
//  ViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class Home: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchView: UIView!

    var initialLoad = true
    var initialAnimation = true
    var navTitle = ""
    var showFilter: Bool = false {
        didSet {
            
            if self.showFilter == true {
                self.filterView.filterViewAnimate()
            }
            else {
                self.filterView.alpha = 0
            }

        }
    }
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var showSearch: Bool = false {
        didSet {
            if showSearch {
                print("active")
                self.searchView.alpha = 1
            }
            else {
                print("not active")
                self.searchView.alpha = 0
            }
        }
    }

    
    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    var searchArray = [Arcana]()
    var preventAnimation = Set<IndexPath>()
    
    var rarityArray = [String]()
    var gesture = UITapGestureRecognizer()
    var longPress = UILongPressGestureRecognizer()
    var filters = [String: [String]]()
    
    
    
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
        
        guard let button = sender as? UIView else {
            return
        }
        
        if searchController.isActive {
            searchController.isActive = false
        }
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = Color.salmon
        alertController.setValue(NSAttributedString(string:
            "정렬", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 20),NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")
        
        let alpha = UIAlertAction(title: "이름순", style: .default, handler: { (action:UIAlertAction) in
            self.arcanaArray = self.arcanaArray.sorted(by: {($0.nameKR) < ($1.nameKR)})
//            self.tableView.reloadData()
            self.animateTable()
            
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
//                self.tableView.reloadData()
                self.animateTable()
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
        

        alertController.addAction(UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        

        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })
    }

    @IBAction func filter(_ sender: AnyObject) {
        if searchController.isActive {
            searchController.isActive = false
        }
        showFilter = !showFilter
    }

    func dismissFilter(_ sender: AnyObject) {
        
        // If search is active and user presses bottom half, dismiss search.
        if searchController.isActive && gesture.location(in: self.view).y > 220 {
            debugPrint("dismiss search")
            gesture.cancelsTouchesInView = true
            searchController.dismiss(animated: true, completion: nil)
            showSearch = false

        }
        
        // If filter is open and user presses on left column, dismiss filter.
        else if showFilter && gesture.location(in: self.view).x < 95 {
            debugPrint("dismiss filter")
            gesture.cancelsTouchesInView = true
            showFilter = false
        }
        else {
            debugPrint("failed")
            gesture.cancelsTouchesInView = false
        }
        
        
    }
    
    
    
    func syncArcana() {

        let ref = FIREBASE_REF.child("arcana")
        
        ref.observe(.childAdded, with: { [weak self] snapshot in

            if let arcana = Arcana(snapshot: snapshot) {

                self?.arcanaArray.insert(arcana, at: 0)
                self?.originalArray.append(arcana)
                if self?.initialLoad == false { //upon first load, don't reload the tableView until all children are loaded
                    self?.tableView.reloadData()
//                    self?.animateTable()
                }
            }
            
            
        })
        
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in

            self?.animateTable()
    
//            self.tableView.reloadData()
            self?.initialLoad = false
        })
        
        ref.observe(.childRemoved, with: { [unowned self] snapshot in
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
        
        ref.observe(.childChanged, with: { [weak self] snapshot in
            
            let uidToChange = snapshot.key
                    
            if let index = self?.originalArray.index(where: {$0.uid == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self?.originalArray[index] = arcana
                }
                
            }
            
            
            if let index = self?.arcanaArray.index(where: {$0.uid == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self?.arcanaArray[index] = arcana
                    self?.tableView.reloadData()
                }
                
            }

        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        filterViewFrame = filterView.frame
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

        tableView.estimatedRowHeight = 90
//        tableView.rowHeight = UITableViewAutomaticDimension
        showFilter = false
        showSearch = false
//        searchView.alpha = 0
//        filterView.alpha = 0.0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            gesture = UITapGestureRecognizer(target: self, action: #selector(Home.dismissFilter(_:)))
            self.view.addGestureRecognizer(gesture)
        }
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(Home.dismissFilter(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Home.handlePanGesture(_:)))
//        self.filterView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
//        self.view.addGestureRecognizer(panGestureRecognizer)
        gesture.cancelsTouchesInView = false
        
//        self.view.addGestureRecognizer(panGestureRecognizer)
        // UISearchController methods
        /*
 gesture = UITapGestureRecognizer(target: self, action: #selector(HomeContainerView.dismissFilter(_:)))
 let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeContainerView.handlePanGesture(_:)))
 self.filterView.addGestureRecognizer(panGestureRecognizer)
 gesture.cancelsTouchesInView = false
 homeView.addGestureRecognizer(gesture)
         */
        searchController = SearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true

        AppRater.appRater.displayAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: row, animated: true)
        }
        
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "showArcana") {
            let arcana: Arcana
            if  searchController.searchBar.text != "" {
                arcana = searchArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            } else {
                arcana = arcanaArray[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            }
            let vc = segue.destination as! ArcanaDetail
            vc.arcana = arcana
            self.view.isUserInteractionEnabled = true
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
//            print("ENDED")
            // animate the side panel open or closed based on whether the view has moved more or less than halfway
            let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
            
            if recognizer.view!.frame.origin.x < 95 {
                recognizer.view!.frame.origin.x = 95
            }
            
            
            if hasMovedGreaterThanHalfway {
                //dismissFilter.
//                print("HAS MOVED MORE THAN HALF, DISMISS")
                filter(self)
            }
            
            
        default:
            break
        }
    }

    
    
    
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension Home: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arcanaArray.count == 0 {
            tableView.isUserInteractionEnabled = false
            tableView.alpha = 0
        }
        else {
            tableView.isUserInteractionEnabled = true
            tableView.fadeIn(withDuration: 0.2)
        }
        if searchController.isActive && searchController.searchBar.text != "" {
            
            if searchArray.count == 0 {
                tableView.alpha = 0
            }
            else {
                tableView.fadeIn(withDuration: 0.2)
            }
            
            return searchArray.count
        }
        
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        
        if arcanaArray.count == 0 {
            cell.arcanaImage.image = #imageLiteral(resourceName: "placeholder")
            
            for i in cell.labelCollection {
                i.alpha = 0
            }
            
        }
        else {
            cell.arcanaNameKR.alpha = 0
            cell.arcanaNameJP.alpha = 0
            for i in cell.labelCollection {
                i.text = nil
                i.backgroundColor = UIColor.white
                i.alpha = 1
            }
            cell.arcanaImage.image = nil
            
            
            let arcana: Arcana
            
            if searchController.isActive && searchController.searchBar.text?.isEmpty == false {
                arcana = searchArray[indexPath.row]
            } else {
                arcana = arcanaArray[indexPath.row]
            }
            
            
            // check if arcana has only name, or nickname.
            if let nnKR = arcana.nickNameKR {
                cell.arcanaNickKR.text = nnKR
                cell.arcanaNickKR.textColor = UIColor.black
            }
            if let nnJP = arcana.nickNameJP {
                
                cell.arcanaNickJP.text = nnJP
                cell.arcanaNickJP.textColor = Color.textGray
            }
            cell.arcanaNameKR.text = arcana.nameKR
            cell.arcanaNameKR.textColor = UIColor.black
            cell.arcanaNameJP.text = arcana.nameJP
            cell.arcanaNameJP.textColor = Color.textGray
            
            cell.arcanaRarity.text = "#\(arcana.rarity)★"
            cell.arcanaRarity.textColor = Color.lightGreen
            cell.arcanaGroup.text = "#\(arcana.group)"
            cell.arcanaGroup.textColor = Color.lightGreen
            cell.arcanaWeapon.text = "#\(arcana.weapon)"
            cell.arcanaWeapon.textColor = Color.lightGreen
            
            if let a = arcana.affiliation {
                if a != "" {
                    cell.arcanaAffiliation.text = "#\(a)"
                    cell.arcanaAffiliation.textColor = Color.lightGreen
                }
                
            }
            
            cell.numberOfViews.text = "조회 \(arcana.numberOfViews)"
            cell.numberOfViews.textColor = Color.lightGreen
            
            cell.arcanaUID = arcana.uid
            
            // Check cache first
            if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/icon.jpg") {
                
                cell.arcanaImage.image = i
                print("LOADED FROM CACHE")
                
            }
                
            else {
                FirebaseService.dataRequest.downloadImage(uid: arcana.uid, sender: cell)
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if initialAnimation == true {
            // don't do anything, animateTable will be called
        }
            
        else {
            let visibleCells = tableView.indexPathsForVisibleRows
            if !preventAnimation.contains(indexPath) {
                preventAnimation.insert(indexPath)
                //            cell.alpha = 0
                cell.transform = CGAffineTransform(translationX: -200, y: 0)
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
                
            }
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.isUserInteractionEnabled = false
        
        self.performSegue(withIdentifier: "showArcana", sender: (indexPath as NSIndexPath).row)
    }
    
    
    func animateTable() {
        tableView.reloadData()
        
        initialAnimation = false
        
        let cells = tableView.visibleCells
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: -200, y: 0)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(index), options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}

// MARK: Search Bar
extension Home: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        // dismiss history if user starts typing.
        if searchText != "" {
//            searchView.alpha = 0
            showSearch = false
        }
        
        searchArray = originalArray.filter { arcana in
            return arcana.nameKR.contains(searchText) || arcana.nameJP.contains(searchText)
        }
        
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        showSearch = true

    }
    
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        showSearch = false
        
    }

}

// MARK: FilterDelegate, TavernViewDelegate
extension Home: FilterDelegate, TavernViewDelegate {
    func didUpdate(_ sender: Filter) {
        DispatchQueue.main.async {
            
            self.preventAnimation.removeAll()
            if let vc = self.childViewControllers[0] as? Filter {
                
                self.filters = vc.filterTypes
                
                // No filters, bring back original array
                if vc.hasFilter == false {
                    // TODO: replace arcanaArray with original arcanaArray.
                    print("NO FILTERS, PREPARING ORIGINAL ARRAY")
                    self.arcanaArray = self.originalArray.reversed()
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
                    
                    self.arcanaArray = Array(finalFilter)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .top, animated: true)
                    
                    
                    
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

}
