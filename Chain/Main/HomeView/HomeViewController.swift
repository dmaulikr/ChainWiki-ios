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
    func pushView(arcanaSection: ArcanaSection, indexPath: IndexPath, cell: UIView)
    func viewMore(arcanaSection: ArcanaSection)
}

class HomeViewController: UIViewController, HomeViewProtocol, UIScrollViewDelegate {
    
    var zoomTransitioningDelegate: TransitioningDelegate?
    weak var welcomeDelegate: WelcomeViewController?
    var thumbnailZoomTransitionAnimator: ZoomingTransitionAnimator?
    var transitionThumbnail: UIImageView?
    var storedOffsets = [Int: CGFloat]()
    
    var observedRefs = [DatabaseReference]()
    
    var rewardArcanaCollectionView: ArcanaHorizontalCollectionView?
    var festivalArcanaCollectionView: ArcanaHorizontalCollectionView?
    var newArcanaCollectionView: ArcanaHorizontalCollectionView?
    var legendArcanaCollectionView: ArcanaHorizontalCollectionView?
    
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
//        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.allowsSelection = false
        tableView.sectionFooterHeight = 0
        
        tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: "HomeViewTableViewCell")
        tableView.register(HomeTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: "HomeTableViewHeaderCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadArcana()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for ref in observedRefs {
            ref.removeAllObservers()
        }
        rewardArcanaArray.removeAll()
        festivalArcanaArray.removeAll()
        newArcanaArray.removeAll()
        legendArcanaArray.removeAll()
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
    
    func pushView(arcanaSection: ArcanaSection, indexPath: IndexPath, cell: UIView) {
        
        guard let arcana = arcanaAtArcanaSectionWithIndexPath(arcanaSection, indexPath: indexPath) else { return }
        
        let detailVC = ArcanaDetail(arcana: arcana, arcanaSection: arcanaSection)
        detailVC.presentedModally = true
        detailVC.modalPresentationStyle = .custom
        zoomTransitioningDelegate = TransitioningDelegate(thumbnailView: cell)
        detailVC.transitioningDelegate = zoomTransitioningDelegate
        zoomTransitioningDelegate?.wireToViewController(viewController: detailVC)
        
//        let navVC = NavigationController(detailVC)
//        navVC.isNavigationBarHidden = true
//        navVC.modalPresentationStyle = .custom
//        navVC.transitioningDelegate = zoomTransitioningDelegate
        
        present(detailVC, animated: true, completion: nil)
//        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func viewMore(arcanaSection: ArcanaSection) {

        let vc = ArcanaCollectionViewController(arcanaSection: arcanaSection)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func reloadArcanaSection(_ section: ArcanaSection) {
        
        if tableView.numberOfSections > section.rawValue {
//            tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
            tableView.reloadData()
        }

    }
    
    func downloadArcana() {
        
        observeFestivalRef()
        
        observeArcanaRef()

        observeLegendRef()
        
        observeRewardRef()
        
    }
    
    func observeRewardRef() {
        
        REWARD_REF.observe(.childAdded, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            let arcanaRef = ARCANA_REF.child(arcanaID)
            self.observedRefs.append(arcanaRef)
            
            arcanaRef.observe(.value, with: { (snapshot) in
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    DispatchQueue.global().async {
                        
                        // if arcana is already in the array, just update it
                        if let index = self.rewardArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                            
                            self.concurrentRewardArcanaQueue.async(flags: .barrier) {
                                self._rewardArcanaArray[index] = arcana
                                DispatchQueue.main.async {
                                    self.reloadArcanaSection(.reward)
                                }
                            }
                        }
                        else {
                            // add the arcana
                            self.concurrentRewardArcanaQueue.async(flags: .barrier) {
                                self._rewardArcanaArray.insert(arcana, at: 0)
                                DispatchQueue.main.async {
                                    self.reloadArcanaSection(.reward)
                                }
                            }
                        }
                    }
                    
                }
            })
        })
        
        REWARD_REF.observe(.childRemoved, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            DispatchQueue.global().async {
                
                if let index = self.rewardArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                    self.concurrentRewardArcanaQueue.async(flags: .barrier) {
                        self._rewardArcanaArray.remove(at: index)
                        DispatchQueue.main.async {
                            self.reloadArcanaSection(.reward)
                        }
                    }
                }
            }
            
        })
    }
    
    func observeFestivalRef() {
        
        FESTIVAL_REF.observe(.childAdded, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            let arcanaRef = ARCANA_REF.child(arcanaID)
            self.observedRefs.append(arcanaRef)
            
            arcanaRef.observe(.value, with: { (snapshot) in
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    DispatchQueue.global().async {
                        
                        // if arcana is already in the array, just update it
                        if let index = self.festivalArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                            
                            self.concurrentFestivalArcanaQueue.async(flags: .barrier) {
                                self._festivalArcanaArray[index] = arcana
                                DispatchQueue.main.async {
                                    self.reloadArcanaSection(.festival)
                                }
                            }
                        }
                        else {
                            // add the arcana
                            self.concurrentFestivalArcanaQueue.async(flags: .barrier) {
                                self._festivalArcanaArray.insert(arcana, at: 0)
                                DispatchQueue.main.async {
                                    self.reloadArcanaSection(.festival)
                                }
                            }
                        }
                    }
                    
                }
            })
        })
        
        FESTIVAL_REF.observe(.childRemoved, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            DispatchQueue.global().async {
                
                if let index = self.festivalArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                    self.concurrentFestivalArcanaQueue.async(flags: .barrier) {
                        self._festivalArcanaArray.remove(at: index)
                        DispatchQueue.main.async {
                            self.reloadArcanaSection(.festival)
                        }
                    }
                }
            }
            
        })
    }
    
    func observeArcanaRef() {
        
        let ref = FIREBASE_REF.child("arcana")
        ref.queryLimited(toLast: 10).observe(.childAdded, with: { snapshot in
            //            ref.observe(.childAdded, with: { snapshot in
            if let arcana = Arcana(snapshot: snapshot) {
                
                self.concurrentNewArcanaQueue.async(flags: .barrier) {
                    self._newArcanaArray.insert(arcana, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        self.reloadArcanaSection(.new)
                    }
                }
            }
            
        })
        
        ref.observe(.childChanged, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            if let arcana = Arcana(snapshot: snapshot) {
                
                DispatchQueue.global().async {
                    
                    if let index = self.newArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                        self.concurrentNewArcanaQueue.async(flags: .barrier) {
                            self._newArcanaArray[index] = arcana
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
//                                self.reloadArcanaSection(.new)
                            }
                        }
                    }

                }
            }
            
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            DispatchQueue.global().async {
                
                if let index = self.newArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                    
                    self.concurrentNewArcanaQueue.async(flags: .barrier) {
                        self._newArcanaArray.remove(at: index)
                        DispatchQueue.main.async {
                            self.reloadArcanaSection(.new)
                        }
                    }
                }
                
            }
            
        })
    }
    
    func observeLegendRef() {
        
        LEGEND_REF.observe(.childAdded, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            let arcanaRef = ARCANA_REF.child(arcanaID)
            self.observedRefs.append(arcanaRef)
            
            arcanaRef.observe(.value, with: { (snapshot) in
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    DispatchQueue.global().async {
                        
                        // if arcana is already in the array, just update it
                        if let index = self.legendArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                            
                            self.concurrentLegendArcanaQueue.async(flags: .barrier) {
                                self._legendArcanaArray[index] = arcana
                                DispatchQueue.main.async {
                                    self.reloadArcanaSection(.legend)
                                }
                            }
                        }
                        else {
                            // add the arcana
                            self.concurrentLegendArcanaQueue.async(flags: .barrier) {
                                self._legendArcanaArray.insert(arcana, at: 0)
                                DispatchQueue.main.async {
                                    self.reloadArcanaSection(.legend)
                                }
                            }
                        }
                    }
                    
                }
            })
        })
        
        LEGEND_REF.observe(.childRemoved, with: { (snapshot) in
            
            let arcanaID = snapshot.key
            
            DispatchQueue.global().async {
                
                if let index = self.legendArcanaArray.index(where: {$0.getUID() == arcanaID}) {
                    self.concurrentLegendArcanaQueue.async(flags: .barrier) {
                        self._legendArcanaArray.remove(at: index)
                        DispatchQueue.main.async {
                            self.reloadArcanaSection(.legend)
                        }
                    }
                }
            }
            
        })
    }
    
    func arcanaAtArcanaSectionWithIndexPath(_ arcanaSection: ArcanaSection, indexPath: IndexPath) -> Arcana? {
        
        var arcana: Arcana?
        
        switch arcanaSection {
        case .reward:
            if indexPath.row < rewardArcanaArray.count {
                arcana = rewardArcanaArray[indexPath.row]
            }
        case .festival:
            if indexPath.row < festivalArcanaArray.count {
                arcana = festivalArcanaArray[indexPath.row]
            }
        case .new:
            if indexPath.row < newArcanaArray.count {
                arcana = newArcanaArray[indexPath.row]
            }
        case .legend:
            if indexPath.row < legendArcanaArray.count {
                arcana = legendArcanaArray[indexPath.row]
            }
        }
        
        return arcana
        
        
    }
    
}
