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
//    var searchArray = [Arcana]()

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
            if initialLoad == true {
//                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            }
            else {
                tableView.reloadData()
            }
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
                
                if arcana.getNameKR().contains("로엔디아") {
                    
                }
                if let arcanaDataSource = self.arcanaDataSource {
                    arcanaDataSource.arcanaArray.insert(arcana, at: 0)
                }
                else {
                    self.arcanaDataSource = ArcanaDataSource([arcana])
                }
                self.originalArray.insert(arcana, at: 0)
//                if self.initialLoad == false {
//                    self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
//                }
                
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            self.arcanaDataSource = ArcanaDataSource(self.originalArray)
            self.initialLoad = false
            
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            
            let uidToRemove = snapshot.key
            
            for (index, arcana) in self.originalArray.enumerated() {
                
                if arcana.getUID() == uidToRemove {
                    self.originalArray.remove(at: index)
                }
                
            }
            
            guard let arcanaDataSource = self.arcanaDataSource else { return }
            for (index, arcana) in arcanaDataSource.arcanaArray.enumerated() {
                if arcana.getUID() == uidToRemove {
                    arcanaDataSource.arcanaArray.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    if let _ = self.tableView.cellForRow(at: indexPath) {
                        if !self.searchController.isActive {
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
//                    self.arcanaDataSource = ArcanaDataSource(self.arcanaArray)
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
            
            guard let arcanaDataSource = self.arcanaDataSource else { return }
            if let index = arcanaDataSource.arcanaArray.index(where: {$0.getUID() == uidToChange}) {
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    arcanaDataSource.arcanaArray[index] = arcana
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
//        if searchController.isActive {
//            arcana = searchArray[row]
//        }
//        else {
        guard let arcanaDataSource = arcanaDataSource else { return }
        arcana = arcanaDataSource.arcanaArray[row]
//        }
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        let arcana: Arcana
//        if searchController.isActive {
//            arcana = searchArray[indexPath.row]
//        }
//        else {
        guard let arcanaDataSource = arcanaDataSource else { return nil }
            arcana = arcanaDataSource.arcanaArray[indexPath.row]
//        }
        
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
            if searchArray.count == 0 {
                tipLabel.fadeIn(withDuration: 0.2)
            }
            else {
                tipLabel.fadeOut(withDuration: 0.2)
            }
            arcanaDataSource = ArcanaDataSource(searchArray)
        }
        else {
            tipLabel.fadeOut(withDuration: 0.2)
            showSearch = true
            arcanaDataSource = ArcanaDataSource(originalArray)
        }

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
        arcanaDataSource = ArcanaDataSource(originalArray)
    }
    
}


