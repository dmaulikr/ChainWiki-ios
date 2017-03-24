//
//  SearchArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

final class SearchArcanaViewController: ArcanaViewController {
    
    let searchController: SearchController = SearchController(searchResultsController: nil)
    
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
        
        searchHistory.didMove(toParentViewController: self)
        
    }

    func setupSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
    }
    
    override func downloadArcana() {
        
        ref.observe(.childAdded, with: { snapshot in

            if let arcana = Arcana(snapshot: snapshot) {

                self.arcanaArray.insert(arcana, at: 0)
                self.originalArray.insert(arcana, at: 0)
                if self.initialLoad == false {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                }
                
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            self.reloadTableView()
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
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
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
                    let indexPath = IndexPath(row: index, section: 0)
                    if let _ = self.tableView.cellForRow(at: indexPath) {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
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
        arcana = arcanaArray[row]
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.row]
        
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
            let searchArray = originalArray.filter { arcana in
                return arcana.getNameKR().contains(searchText) || arcana.getNameJP().contains(searchText)
            }
            arcanaArray = searchArray
        }
        else {
            showSearch = true
            arcanaArray = originalArray
        }
        reloadTableView()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        showSearch = true
        showFilter = false
        filterViewController?.clearFilters()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        showSearch = false
        arcanaArray = originalArray
        reloadTableView()
    }
    
}


