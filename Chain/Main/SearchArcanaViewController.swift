//
//  SearchArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SearchArcanaViewController: ArcanaViewController {
    
    let searchController: SearchController = SearchController(searchResultsController: nil)
    var searchArray = [Arcana]()

    fileprivate let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
        
    }()
    
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
    
    override var arcanaDataSource: ArcanaDataSource? {
        didSet {
            tableView.dataSource = arcanaDataSource
            tableView.reloadData()
            tableView.fadeIn(withDuration: 0.2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(searchView)
        searchView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 220)

    }
    
    override func setupChildViews() {
        
        super.setupChildViews()
        let searchHistory = SearchHistory()
        
        addChildViewController(searchHistory)
        
        searchView.addSubview(searchHistory.view)
        searchHistory.view.frame = searchView.frame
        
    }

    func setupSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
    }
    
    override func downloadArcana() {
        
        arcanaRefHandle = ref.observe(.childAdded, with: { snapshot in
            
            if let arcana = Arcana(snapshot: snapshot) {
                
                self.arcanaArray.insert(arcana, at: 0)
                self.originalArray.insert(arcana, at: 0)
                if self.initialLoad == false { //upon first load, don't reload the tableView until all children are loaded
                    //                    self.tableView.reloadData()
                }
                
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            //            self.animateTable()
            self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
            self.initialLoad = false
            if let refHandle = self.arcanaRefHandle {
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
                    self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
//                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
                
            }
            
        })
        
    }

    override func sort(_ sender: AnyObject) {
        
        if searchController.isActive {
            searchController.isActive = false
        }
        
        super.sort(sender)
        
    }
    
    override func toggleFilterView() {
        if searchController.isActive {
            searchController.isActive = false
        }
        super.toggleFilterView()
    }
    
    override func dismissFilter() {
        
        // If search is active and user presses bottom half, dismiss search.
        if searchController.searchBar.text?.characters.count == 0 && searchController.isActive && gesture.location(in: self.view).y > 220 {
            debugPrint("dismiss search")
            gesture.cancelsTouchesInView = true
            searchController.dismiss(animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
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

extension SearchArcanaViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
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


