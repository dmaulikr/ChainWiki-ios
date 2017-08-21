//
//  SearchArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class SearchArcanaViewController: ArcanaViewController {
    
    let searchBar: SearchBar = SearchBar()
    override var arcanaVC: ArcanaVC {
        get {
            return .search
        }
        set {}
    }

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    fileprivate var showSearch: Bool = false {
        didSet {
            if showSearch {
                searchView.alpha = 1
                searchBar.showsCancelButton = true
            }
            else {
                searchView.alpha = 0
                searchBar.showsCancelButton = false
            }
        }
    }
    
    fileprivate lazy var festivalButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "FESTIVAL", style: .plain, target: self, action: #selector(showFestival))
        return button
    }()
    
    fileprivate lazy var homeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "홈", style: .plain, target: self, action: #selector(showHome))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        checkUpdate()
        if defaults.getShowedArcanaViewSelection() == false {
            arcanaView = .list
        }
        else {
            getArcanaView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("SearchArcanaView", screenClass: nil)
        
        if !defaults.pushShown() {
            defaults.setPushShown()
            let vc = PushNotificationViewController(nibName: "PushNotificationViewController", bundle: nil)
            present(NavigationController(vc), animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if searchBar.isFirstResponder && searchBar.text == "" {
            searchBarCancelButtonClicked(searchBar)
        }
    }
    
    var headerViewHeightConstraint: NSLayoutConstraint?

    override func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
//        navigationItem.leftBarButtonItem = homeButton
        
        setupColumns()
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(headerView)
        view.addSubview(tipLabel)
        view.addSubview(filterView)

        headerView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

        tableView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let headerViewHeight: CGFloat
        if traitCollection.horizontalSizeClass == .compact {
            
            headerViewHeight = 70
            
//            tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0)
//            tableViewBottomConstraint?.isActive = true
            
            filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
        }
        else {
            headerViewHeight = 100
            
            filterView.anchor(top: headerView.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
            
        }
        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerViewHeightConstraint?.isActive = true
        
        tipLabel.anchorCenterSuperview()
        
        setupChildViews()
        
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            
//            if !initialLoad {
//                setupColumns()
//            }
//            
//        }
//        
//    }
    
    override func setupChildViews() {
        
        super.setupChildViews()
        
        view.addSubview(searchView)
        searchView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let searchHistory = SearchHistory()

        addChildViewController(searchHistory)
        
        searchView.addSubview(searchHistory.view)
        
        searchHistory.view.anchor(top: searchView.topAnchor, leading: searchView.leadingAnchor, trailing: searchView.trailingAnchor, bottom: searchView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        searchHistory.didMove(toParentViewController: self)
        
    }

    override func setupNavBar() {
        super.setupNavBar()
        title = "아르카나"
        
        FESTIVAL_REF.observeSingleEvent(of: .value, with: { snapshot in
            
            DispatchQueue.main.async {
                if snapshot.exists() {
                    self.navigationItem.leftBarButtonItem = self.festivalButton
                }
                else {
                    self.navigationItem.leftBarButtonItem = nil
                }
            }

            
        })

    }
    
    func setupSearchBar() {
        
        definesPresentationContext = true

        searchBar.delegate = self
        
        headerView.addSubview(searchBar)
        headerView.addSubview(arcanaCountView)
        
        let searchBarHeight: CGFloat
        let arcanaCountViewHeight: CGFloat

        if traitCollection.horizontalSizeClass == .compact {
            searchBarHeight = 40
            arcanaCountViewHeight = 30
        }
        else {
            searchBarHeight = 60
            arcanaCountViewHeight = 40
        }
        searchBar.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: searchBarHeight)
        
        arcanaCountView.anchor(top: searchBar.bottomAnchor, leading: headerView.leadingAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: arcanaCountViewHeight)

        view.addSubview(searchView)
        searchView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 200)
        
    }
    
    func checkUpdate() {
        
        let checkUpdateRef = FIREBASE_REF.child("update")
        checkUpdateRef.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let installedVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let updateDict = snapshot.value as? [String:String], let newestVersion = updateDict["currentVersion"], let info = updateDict["info"] else { return }
            
            if installedVersion < newestVersion {
                // present alert to update.
                self.showUpdateAlert(text: info)
            }
        })
    }
    
    @objc
    func showHome() {
        
        let vc = HomeViewController()
        
        UIView.animate(withDuration: 0.2) {
            self.splitViewController?.preferredDisplayMode = .primaryHidden
        }
        self.splitViewController?.showDetailViewController(NavigationController(vc), sender: nil)
        
    }
    
    override func downloadArcana() {
        
        // For UI Testing.
//        ref.queryLimited(toFirst: 800).observe(.childAdded, with: { snapshot in
//         ref.queryLimited(toLast: 10).observe(.childAdded, with: { snapshot in
        ref.observe(.childAdded, with: { snapshot in
        
            if let arcana = Arcana(snapshot: snapshot) {
                
                if !self.showFilter && self.searchBar.text == "" && self.filters.count == 0 {

                    self.concurrentArcanaQueue.async(flags: .barrier) {
                        self._arcanaArray.insert(arcana, at: 0)
                        if !self.initialLoad {
                            DispatchQueue.main.async {
                                self.reloadView()
                            }
                        }
                    }
                    
                    self.concurrentArcanaOriginalQueue.async(flags: .barrier) {
                        self._originalArray.insert(arcana, at: 0)
                    }
                }
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            self.concurrentArcanaQueue.async(flags: .barrier) {
                self.initialLoad = false
            }

            DispatchQueue.main.async {
                self.welcomeDelegate?.animatedLogoView.finishAnimation()
                self.reloadView()
            }
            
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            DispatchQueue.global().async {
                
                if let index = self.arcanaArray.index(where: {$0.getUID() == arcanaID}) {
                    
                    self.concurrentArcanaQueue.async(flags: .barrier) {
                        self._arcanaArray.remove(at: index)
                        DispatchQueue.main.async {
                            self.deleteIndexPathAt(index: index)
                        }
                    }
                }
                
                if let index = self.originalArray.index(where: {$0.getUID() == arcanaID}) {
                    self.concurrentArcanaOriginalQueue.async(flags: .barrier) {
                        self._originalArray.remove(at: index)
                    }
                }
                
            }
            
        })
        
        ref.observe(.childChanged, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            if let arcana = Arcana(snapshot: snapshot) {

                DispatchQueue.global(qos: .userInitiated).async {
                    
                    if let index = self.arcanaArray.index(where: {$0.getUID() == arcanaID}) {
                        self.concurrentArcanaQueue.async(flags: .barrier) {
                            self._arcanaArray[index] = arcana
                            DispatchQueue.global(qos: .userInitiated).async {
                                self.reloadIndexPathAt(index)
                            }
                        }
                    }
                    
                    if let index = self.originalArray.index(where: {$0.getUID() == arcanaID}) {
                        self.concurrentArcanaOriginalQueue.async(flags: .barrier) {
                            self._originalArray[index] = arcana
                        }
                    }
                }
            }

        })
        
    }
    
    override func sort(_ sender: AnyObject) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        super.sort(sender)
        
    }
    
    override func toggleFilterView() {
        if searchBar.isFirstResponder {
            searchBarCancelButtonClicked(searchBar)
        }
        super.toggleFilterView()
    }
    
    override func dismissFilter() {
        
        // If search is active and user presses bottom half, dismiss search.
        if searchBar.text?.characters.count == 0 && searchBar.isFirstResponder && gesture.location(in: searchView).y > 200 {
            debugPrint("dismiss search")
            gesture.cancelsTouchesInView = true
            searchBar.resignFirstResponder()
            showSearch = false
            
        }
        // If filter is open and user presses on left column, dismiss filter.
        else if showFilter && gesture.location(in: self.view).x < 95 {
            gesture.cancelsTouchesInView = true
            showFilter = false
        }
            
        else {
            gesture.cancelsTouchesInView = false
        }

    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        showSearchBar(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard let superview = scrollView.superview else { return }
        
        let translation = scrollView.panGestureRecognizer.translation(in: superview)

        if translation.y <= 0 {
            // if moving down the tableView
            showSearchBar(false)
        }
 
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        guard let superview = scrollView.superview else { return }
        
        let translation = scrollView.panGestureRecognizer.translation(in: superview)
        
        if decelerate == true {
            if translation.y > 0 {
                showSearchBar(true)
            }
        }
    }

    func showSearchBar(_ show: Bool) {
        
        let headerViewHeight: CGFloat
        if traitCollection.horizontalSizeClass == .compact {
            headerViewHeight = 70
        }
        else {
            headerViewHeight = 100
        }
        if show {
            if headerViewHeightConstraint?.constant != headerViewHeight {
                headerViewHeightConstraint?.constant = headerViewHeight
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        else {
            if headerViewHeightConstraint?.constant != 0 {
                headerViewHeightConstraint?.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func showUpdateAlert(text: String) {
        
        let alert = UIAlertController(title: "새로운 버전이 출시되었습니다.", message: text, preferredStyle: .alert)
        alert.view.tintColor = Color.salmon
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        
        let confirmAction = UIAlertAction(title: "앱스토어 가기", style: .default) { (action) in
            guard let url = NSURL(string: "itms-apps://itunes.apple.com/app/id1165642488") as URL? else { return }
            UIApplication.shared.openURL(url)
        }
        
        let cancelAction = UIAlertAction(title: "나중에", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            alert.view.tintColor = Color.salmon
        }

    }
    
    @objc
    func showFestival() {
        
        let vc = FestivalViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SearchArcanaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            self.showSearch = false
            let searchArray = self.originalArray.filter { arcana in
                return arcana.getNameKR().contains(searchText) || arcana.getNameJP().contains(searchText)
            }
            concurrentArcanaQueue.async(flags: .barrier) {
                self._arcanaArray = searchArray
                DispatchQueue.main.async {
                    self.reloadView()
                }
            }
        }
        else {
            self.showSearch = true
            concurrentArcanaQueue.async(flags: .barrier) {
            self._arcanaArray = self.originalArray
                DispatchQueue.main.async {
                    self.reloadView()
                }
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            showSearch = true
        }
        showFilter = false
        filterViewController?.clearFilters()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        showSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        showSearch = false
        
        concurrentArcanaQueue.async(flags: .barrier) {
            self.arcanaArray = self.originalArray
            DispatchQueue.main.async {
                self.reloadView()
            }
        }
        
    }
    
}
