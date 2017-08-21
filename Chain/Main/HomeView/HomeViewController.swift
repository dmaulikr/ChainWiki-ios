//
//  HomeViewController.swift
//  Chain
//
//  Created by Jitae Kim on 7/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

protocol HomeViewProtocol: class {
    func pushView(arcanaSection: ArcanaSection, index: Int, cell: UIView)
    func viewMore(arcanaSection: ArcanaSection)
}

class HomeViewController: UIViewController, HomeViewProtocol {
    
    var zoomTransitioningDelegate: TransitioningDelegate?
    weak var welcomeDelegate: WelcomeViewController?
    var thumbnailZoomTransitionAnimator: ZoomingTransitionAnimator?
    var transitionThumbnail: UIImageView?
    
    let concurrentRewardArcanaQueue =
        DispatchQueue(
            label: "com.jk.cckorea.rewardArcanaArrayQueue",
            attributes: .concurrent)
    
    let concurrentFestivalArcanaQueue =
        DispatchQueue(
            label: "com.jk.cckorea.festivalArcanaArrayQueue",
            attributes: .concurrent)
    
    let concurrentNewArcanaQueue =
        DispatchQueue(
            label: "com.jk.cckorea.newArcanaArrayQueue",
            attributes: .concurrent)
    
    let concurrentLegendArcanaQueue =
        DispatchQueue(
            label: "com.jk.cckorea.legendArcanaArrayQueue",
            attributes: .concurrent)
    
    // Not thread-safe
    var _rewardArcanaArray: [Arcana] = []
    var _festivalArcanaArray: [Arcana] = []
    var _newArcanaArray: [Arcana] = []
    var _legendArcanaArray: [Arcana] = []
    
    var rewardArcanaArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentRewardArcanaQueue.sync {
                arcanaCopy = self._rewardArcanaArray
            }
            return arcanaCopy
        }
        set {
            _rewardArcanaArray = newValue
        }
    }
    
    var festivalArcanaArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentFestivalArcanaQueue.sync {
                arcanaCopy = self._festivalArcanaArray
            }
            return arcanaCopy
        }
        set {
            _festivalArcanaArray = newValue
        }
    }
    
    var newArcanaArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentNewArcanaQueue.sync {
                arcanaCopy = self._newArcanaArray
            }
            return arcanaCopy
        }
        set {
            _newArcanaArray = newValue
        }
    }
    
    var legendArcanaArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentLegendArcanaQueue.sync {
                arcanaCopy = self._legendArcanaArray
            }
            return arcanaCopy
        }
        set {
            _legendArcanaArray = newValue
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
//        if #available(iOS 11.0, *) {
//            tableView.dragDelegate = self
//        }
//
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: "HomeViewTableViewCell")
        tableView.register(HomeTableViewHeaderCell.self, forCellReuseIdentifier: "HomeTableViewHeaderCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        downloadArcana()
    }
    
    func setupViews() {
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//        }
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "아르카나"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func pushView(arcanaSection: ArcanaSection, index: Int, cell: UIView) {
        
        let arcana: Arcana
        
        switch arcanaSection {
        case .reward:
            arcana = rewardArcanaArray[index]
        case .festival:
            arcana = festivalArcanaArray[index]
        case .new:
            arcana = newArcanaArray[index]
        case .legend:
            arcana = legendArcanaArray[index]
        }
        
//        let detailVC = ArcanaDetail(arcana: arcana)
        let detailVC = ArcanaDetail(arcana: arcana, arcanaSection: arcanaSection)
//        detailVC.view.heroID = arcana.getUID() + "\(arcanaSection.rawValue)"
        let navVC = NavigationController(detailVC)
        navVC.isNavigationBarHidden = true
        navVC.modalPresentationStyle = .custom
        zoomTransitioningDelegate = TransitioningDelegate(thumbnailView: cell)
        navVC.transitioningDelegate = zoomTransitioningDelegate
        
        let arcanaVC = navVC.topViewController as! ArcanaDetail
        arcanaVC.interactor = zoomTransitioningDelegate
        
        present(navVC, animated: true, completion: nil)
//        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func viewMore(arcanaSection: ArcanaSection) {
        
        navigationController?.delegate = nil
        
//        let vc = SearchArcanaViewController()
//        navigationController?.pushViewController(vc, animated: true)
        let welcomeVC = WelcomeViewController()
        let masterNavVC = splitViewController!.viewControllers.first as! NavigationController
        let masterVC = masterNavVC.topViewController as! SearchArcanaViewController

        masterVC.welcomeDelegate = welcomeVC

//        arcanaDetailVC.navigationItem.leftItemsSupplementBackButton = true
//        arcanaDetailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        UIView.animate(withDuration: 0.2) {
            self.splitViewController?.preferredDisplayMode = .allVisible
        }
        
        splitViewController?.showDetailViewController(NavigationController(welcomeVC), sender: nil)
    }
    
    func downloadArcana() {
        
        // Festival
        FESTIVAL_REF.queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            let group = DispatchGroup()
            
            for id in uid {
                group.enter()
                
                let ref = ARCANA_REF.child(id)
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        
                        self.concurrentFestivalArcanaQueue.async(flags: .barrier) {
                            self._festivalArcanaArray.append(arcana)
                        }
                    }
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.tableView.reloadData()
            })
            
        })
        
        
        // New arcana
        let ref = FIREBASE_REF.child("arcana")
        ref.queryLimited(toLast: 10).observe(.childAdded, with: { snapshot in
//            ref.observe(.childAdded, with: { snapshot in
            if let arcana = Arcana(snapshot: snapshot) {
                
                self.concurrentNewArcanaQueue.async(flags: .barrier) {
                    self._newArcanaArray.insert(arcana, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        })
        
        
        LEGEND_REF.observe(.childAdded, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            // using the ID, go through /arcana to get full data
            let arcanaRef = ARCANA_REF.child(arcanaID)
            arcanaRef.observe(.value, with: { (snapshot) in
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.concurrentLegendArcanaQueue.async(flags: .barrier) {
                        self._legendArcanaArray.insert(arcana, at: 0)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
            
        })
        
        REWARD_REF.observe(.childAdded, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            let arcanaRef = ARCANA_REF.child(arcanaID)
            arcanaRef.observe(.value, with: { (snapshot) in
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.concurrentRewardArcanaQueue.async(flags: .barrier) {
                        self._rewardArcanaArray.insert(arcana, at: 0)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        })
        
    }
    
}
