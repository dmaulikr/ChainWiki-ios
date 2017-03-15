//
//  ArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaViewController: UIViewController {

    var ref: FIRDatabaseReference = FIREBASE_REF.child("arcana")
    var arcanaRefHandle: FIRDatabaseHandle?
    
    let searchController: SearchController = SearchController(searchResultsController: nil)
    
    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    var searchArray = [Arcana]()
    fileprivate var filters = [String: [String]]()
    fileprivate var initialLoad = true
    
    var arcanaDataSource: ArcanaDataSource? {
        didSet {
            tableView.dataSource = arcanaDataSource
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self

        tableView.estimatedRowHeight = 90
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        
        return tableView
    }()

    fileprivate let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    fileprivate let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
        
    }()

    fileprivate var showFilter: Bool = false {
        didSet {
            
            if self.showFilter == true {
                self.filterView.filterViewAnimate()
            }
            else {
                self.filterView.alpha = 0
            }
            
        }
    }
    
    fileprivate var showSearch: Bool = false {
        didSet {
            if showSearch {
                self.searchView.alpha = 1
            }
            else {
                self.searchView.alpha = 0
            }
        }
    }
    
    fileprivate var gesture = UITapGestureRecognizer()
    fileprivate var longPress = UILongPressGestureRecognizer()

    init() {
        ref = FIREBASE_REF.child("arcana")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard let refHandle = self.arcanaRefHandle else { return }
        ref.removeObserver(withHandle: refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        setupSearchBar()
        setupGestures()
        syncArcana()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let row = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: row, animated: true)
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(filterView)
        view.addSubview(searchView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
        searchView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 220)
        
        setupChildViews()

    }
    
    func setupChildViews() {
        
        // Setup FilterView
        let filterMenu = Filter()
        filterMenu.delegate = self
        
        addChildViewController(filterMenu)
        
        filterView.addSubview(filterMenu.view)
        filterMenu.view.frame = filterView.frame
        
        // Setup SearchView
        let searchHistory = SearchHistory()
        
        addChildViewController(searchHistory)
        
        searchView.addSubview(searchHistory.view)
        searchHistory.view.frame = searchView.frame
    }

    func setupNavBar() {
        
        let filter = UIButton()
        filter.setImage(UIImage(named: "filter.png"), for: .normal)
        filter.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filter.addTarget(self, action: #selector(filterArcana), for: .touchUpInside)
        let filterButton = UIBarButtonItem()
        filterButton.customView = filter
        
        let sort = UIButton()
        sort.setImage(UIImage(named: "sort.png"), for: .normal)
        sort.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        sort.addTarget(self, action: #selector(sort(_:)), for: .touchUpInside)
        let sortButton = UIBarButtonItem()
        sortButton.customView = sort
        
        navigationItem.rightBarButtonItems = [filterButton,sortButton]
    }
    
    func setupSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
    }
    
    func setupGestures() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            gesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
            view.addGestureRecognizer(gesture)
        }
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(dismissFilter))
        gesture.cancelsTouchesInView = false
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
    }
    
    func syncArcana() {

        arcanaRefHandle = ref.observe(.childAdded, with: { snapshot in
            
            if let arcana = Arcana(snapshot: snapshot) {
                
                self.arcanaArray.insert(arcana, at: 0)
                self.originalArray.insert(arcana, at: 0)
                if self.initialLoad == false { //upon first load, don't reload the tableView until all children are loaded
                    self.tableView.reloadData()
                }
                
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
//            self.animateTable()
            self.tableView.reloadData()
            self.initialLoad = false
            if let refHandle = self.arcanaRefHandle {
                self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
                self.ref.removeObserver(withHandle: refHandle)
                
            }
            
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            
            let uidToRemove = snapshot.key
            
            for (index, arcana) in self.originalArray.enumerated() {
                if arcana.getUID() == uidToRemove {
                    self.originalArray.remove(at: index)
                    
                }
                
            }
            
            for (index, arcana) in self.arcanaArray.enumerated() {
                if arcana.getUID() == uidToRemove {
                    self.arcanaArray.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
            }
        })
        
        ref.observe(.childChanged, with: { snapshot in
            
            let uidToChange = snapshot.key
            
            if let index = self.originalArray.index(where: {$0.getUID() == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.originalArray[index] = arcana
                }
                
            }
            
            if let index = self.arcanaArray.index(where: {$0.getUID() == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.arcanaArray[index] = arcana
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
                
            }
            
        })
        
    }
    
    private func sortArcanaByName() {
        arcanaArray = self.arcanaArray.sorted(by: {($0.getNameKR()) < ($1.getNameKR())})
    }
    
    private func sortArcanaByRecent() {
        arcanaArray = originalArray.reversed()
    }
    
    private func sortArcanaByNumberOfViews() {
        
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
        
    }

    func sort(_ sender: AnyObject) {
        
        guard let button = sender as? UIView else { return }
        
        if searchController.isActive {
            searchController.isActive = false
        }
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = Color.salmon
        alertController.setValue(NSAttributedString(string:
            "정렬", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 20),NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")
        
        let alpha = UIAlertAction(title: "이름순", style: .default, handler: { action in
            self.sortArcanaByName()
        })
        alertController.addAction(alpha)
        
        let recent = UIAlertAction(title: "최신순", style: .default, handler: { action in
            self.sortArcanaByRecent()
        })
        alertController.addAction(recent)
        
        let views = UIAlertAction(title: "조회순", style: .default, handler: { action in
            self.sortArcanaByNumberOfViews()
        })
        alertController.addAction(views)
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        
        present(alertController, animated: true, completion: { () -> () in
            alertController.view.tintColor = Color.salmon
        })
    }
    
    func filterArcana() {
        
        if searchController.isActive {
            searchController.isActive = false
        }
        showFilter = !showFilter
        
    }

    func dismissFilter() {
        
        // If search is active and user presses bottom half, dismiss search.
        
        if searchController.searchBar.text?.characters.count == 0 && searchController.isActive && gesture.location(in: self.view).y > 220 {
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

}

extension ArcanaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arcanaArray.count == 0 {
            tableView.alpha = 0
        }
        else {
            tableView.alpha = 1
        }
        
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        let arcana: Arcana
        if searchController.isActive {
            arcana = searchArray[row]
        }
        else {
            arcana = arcanaArray[row]
        }
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArcanaViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        // dismiss history if user starts typing.
        if searchText != "" {
            showSearch = false
        }
        
        searchArray = originalArray.filter { arcana in
            return arcana.getNameKR().contains(searchText) || arcana.getNameJP().contains(searchText)
        }
        
        arcanaDataSource = ArcanaDataSource(searchArray)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        showSearch = true
        showFilter = false
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        showSearch = false
        arcanaDataSource = ArcanaDataSource(arcanaArray)
    }
    
}

extension ArcanaViewController: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        let arcana: Arcana
        if searchController.isActive {
            arcana = searchArray[indexPath.row]
        }
        else {
            arcana = arcanaArray[indexPath.row]
        }
        
        let vc = ArcanaPeekPreview(arcana: arcana)
        vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)
        
        return vc
    }
    
}

extension ArcanaViewController: FilterDelegate {
    
    func didUpdate(_ sender: Filter) {
        DispatchQueue.main.async {
            
//            self.preventAnimation.removeAll()
            self.filters = sender.filterTypes
            
            if sender.hasFilter == false {
                self.arcanaArray = self.originalArray
                self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
                
            }
                
            else {
                
                var raritySet = Set<Arcana>()
                if let r = self.filters["rarity"] {
                    
                    for rarity in r {
                        print("FOR RARITY \(rarity)")
                        let filteredRarity = self.originalArray.filter({$0.getRarity() == rarity})
                        
                        raritySet = raritySet.union(Set(filteredRarity))
                    }
                    
                }
                
                
                var groupSet = Set<Arcana>()
                if let g = self.filters["group"] {
                    
                    for group in g {
                        print(group)
                        let filteredGroup = self.originalArray.filter({$0.getGroup() == group})
                        groupSet = groupSet.union(Set(filteredGroup))
                    }
                    
                }
                
                var weaponSet = Set<Arcana>()
                if let w = self.filters["weapon"] {
                    
                    for weapon in w {
                        let filteredWeapon = self.originalArray.filter({$0.getWeapon()[$0.getWeapon().startIndex] == weapon[weapon.startIndex]})
                        weaponSet = weaponSet.union(Set(filteredWeapon))
                    }
                    
                }
                
                var affiliationSet = Set<Arcana>()
                if let a = self.filters["affiliation"] {
                    
                    for affiliation in a {
                        let filteredAffiliation = self.originalArray.filter({$0.getAffiliation() != nil && $0.getAffiliation()!.contains(affiliation)})
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
                
                if self.arcanaArray.count > 0 {
                    self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
            
        }
    }
}
