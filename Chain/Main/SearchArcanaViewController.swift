//
//  SearchArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if defaults.getShowedArcanaViewSelection() == false {
            
            let vc = ArcanaViewTypePageViewController(selectedArcanaViews: [.all], showTip: true)
            present(vc, animated: true, completion: nil)
            
        }
        else {
            getArcanaView()
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
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(headerView)
        view.addSubview(tipLabel)
        view.addSubview(filterView)
        
        headerView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let headerViewHeight: CGFloat
        if horizontalSize == .compact {
            
            headerViewHeight = 70

            tableView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
            
            collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
            
            filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
        }
        else {
            headerViewHeight = 100
            
//            if ISIPADPRO {
//                showFilter = true
//                collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: nil, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//
//                filterView.anchor(top: headerView.bottomAnchor, leading: collectionView.trailingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 367, heightConstant: 0)
//            }
//            else {
                collectionView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

                filterView.anchor(top: headerView.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
//            }

        }
        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerViewHeightConstraint?.isActive = true
        
        tipLabel.anchorCenterSuperview()
        
        setupChildViews()
        
    }
    
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
//        navigationItem.leftBarButtonItem = toggleArcanaViewButton
    }
    
    func setupSearchBar() {
        
        definesPresentationContext = true

        searchBar.delegate = self
        
        headerView.addSubview(searchBar)
        headerView.addSubview(arcanaCountView)
        
        let searchBarHeight: CGFloat
        let arcanaCountViewHeight: CGFloat

        if horizontalSize == .compact {
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
    
    override func downloadArcana() {
        
        ref.observe(.childAdded, with: { snapshot in

            if let arcana = Arcana(snapshot: snapshot) {

                self.arcanaArray.insert(arcana, at: 0)
                self.originalArray.insert(arcana, at: 0)
                if self.initialLoad == false {
                    self.insertIndexPathAt(index: 0)
                }
                
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            self.reloadView()
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            
            let uidToRemove = snapshot.key
            
            for (index, arcana) in self.originalArray.enumerated() {
                
                if arcana.getUID() == uidToRemove {
                    self.originalArray.remove(at: index)
                    break
                }
                
            }
            
            for (index, arcana) in self.arcanaArray.enumerated() {
                if arcana.getUID() == uidToRemove {
                    self.arcanaArray.remove(at: index)
                    self.deleteIndexPathAt(index: index)
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

                    self.reloadIndexPathAt(index)
                    let indexPath = IndexPath(row: index, section: 0)
                    if let selectedIndexPath = self.selectedIndexPath, selectedIndexPath == indexPath {
                        self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .none)
                        self.selectedIndexPath = nil
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let superview = scrollView.superview else { return }
        
        let translation = scrollView.panGestureRecognizer.translation(in: superview)

        if translation.y > 0 {
            // if moving up the tableView
            showSearchBar(true)
        } else {
            // if moving down the tableView
            showSearchBar(false)
        }
 
    }

    func showSearchBar(_ show: Bool) {
        
        let headerViewHeight: CGFloat
        if horizontalSize == .compact {
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

}

extension SearchArcanaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            showSearch = false
            let searchArray = originalArray.filter { arcana in
                return arcana.getNameKR().contains(searchText) || arcana.getNameJP().contains(searchText)
            }
            arcanaArray = searchArray
        }
        else {
            showSearch = true
            arcanaArray = originalArray
        }
        reloadView()

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
        arcanaArray = originalArray
        reloadView()
    }
    
}


