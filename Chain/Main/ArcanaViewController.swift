//
//  ArcanaViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum ArcanaView: String {
    case list
    case main
    case profile
    case mainGrid
}

enum ArcanaVC {
    case search
    case tavern
    case favorites
}

class ArcanaViewController: UIViewController {
    
    weak var welcomeDelegate: WelcomeViewController?

    let concurrentArcanaQueue =
        DispatchQueue(
            label: "com.jk.cckorea.arcanaArrayQueue",
            attributes: .concurrent)
    
    let concurrentArcanaOriginalQueue =
        DispatchQueue(
            label: "com.jk.cckorea.originalArrayQueue",
            attributes: .concurrent)
    
    var ref: DatabaseReference = FIREBASE_REF.child("arcana")
    var filterViewController: FilterViewController?
    
    var arcanaVC: ArcanaVC = .search
    
    // Not thread-safe
    var _arcanaArray: [Arcana] = []
    var _originalArray: [Arcana] = []
    
    // Thread-safe
    var arcanaArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentArcanaQueue.sync {
                arcanaCopy = self._arcanaArray
            }
            return arcanaCopy
        }
        set {
            _arcanaArray = newValue
        }
    }

    var originalArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentArcanaOriginalQueue.sync {
                arcanaCopy = self._originalArray
            }
            return arcanaCopy
        }
        set {
            _originalArray = newValue
        }
    }
    
    var filters = [String: [String]]()
    var initialLoad = true
    var selectedIndexPath: IndexPath?
    var arcanaView: ArcanaView = .list

    var numberOfProfileImageColumns: CGFloat = 4
    var numberOfListColumns: CGFloat = 2
//    lazy var toggleArcanaViewButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleArcanaView))
//        return button
//    }()
    
    let arcanaCountView = SectionHeader(sectionTitle: "")
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            tableView.dragDelegate = self
        }
        
        tableView.backgroundColor = .white
        tableView.alpha = 0
        tableView.estimatedRowHeight = 90
        
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        tableView.register(ArcanaMainImageCell.self, forCellReuseIdentifier: "ArcanaMainImageCell")
        
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 11.0, *) {
            collectionView.dragDelegate = self
        }
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.alpha = 0
        
        collectionView.register(ArcanaIconCell.self, forCellWithReuseIdentifier: "ArcanaIconCell")
        collectionView.register(ArcanaIconLabelCell.self, forCellWithReuseIdentifier: "ArcanaIconLabelCell")
        collectionView.register(MainListTableView.self, forCellWithReuseIdentifier: "MainListTableView")
        
        return collectionView
    }()
    
    let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    var filterViewLeadingConstraint: NSLayoutConstraint?

    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "아르카나가 없어요 :("
        label.textColor = Color.textGray
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
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
    
    var gesture = UITapGestureRecognizer()
    var longPress = UILongPressGestureRecognizer()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ref.removeAllObservers()
        NotificationCenter.default.removeObserver(self, name: ARCANAVIEWUPDATENOTIFICATIONNAME, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArcanaViewTypeObserver()
        setupViews()
        setupNavBar()
        setupGestures()
        downloadArcana()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let row = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: row, animated: true)
    }
    
    var updatedSize: CGSize!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .phone {
            return
        }
        updatedSize = size
        
//        print(updatedSize)
        collectionView.collectionViewLayout.invalidateLayout()
    }
        
    func setupViews() {
        
        setupColumns()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(tipLabel)
        view.addSubview(filterView)

        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

        tipLabel.anchorCenterSuperview()
        
        filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
        
        setupChildViews()

    }
    
    func setupColumns() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            numberOfProfileImageColumns = 4
        }
        else {
            if traitCollection.horizontalSizeClass == .compact {
                numberOfListColumns = 1
                numberOfProfileImageColumns = 4
            }
            else {
                numberOfListColumns = 2
                numberOfProfileImageColumns = 8
            }
        }
        
    }
    
    func setupChildViews() {
        
        filterViewController = FilterViewController()
        
        guard let filterViewController = filterViewController else { return }
        
        filterViewController.delegate = self
        
        addChildViewController(filterViewController)
        
        filterView.addSubview(filterViewController.view)
        filterViewController.view.frame = filterView.frame
        
        filterViewController.didMove(toParentViewController: self)

    }

    func setupNavBar() {
        
        let filter = UIButton()
        filter.setImage(UIImage(named: "filter.png"), for: .normal)
        filter.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        filter.addTarget(self, action: #selector(toggleFilterView), for: .touchUpInside)
        let filterButton = UIBarButtonItem()
        filterButton.customView = filter
        
        let sort = UIButton()
        sort.setImage(UIImage(named: "sort.png"), for: .normal)
        sort.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        sort.addTarget(self, action: #selector(sort(_:)), for: .touchUpInside)
        let sortButton = UIBarButtonItem()
        sortButton.customView = sort
        
        navigationItem.rightBarButtonItems = [filterButton,sortButton]
    }

    func setupGestures() {

        gesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilter))
        view.addGestureRecognizer(gesture)
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(dismissFilter))
        gesture.cancelsTouchesInView = false
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        
        
    }
    
    func setupArcanaViewTypeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateArcanaView), name: ARCANAVIEWUPDATENOTIFICATIONNAME, object: nil)
    }
    
    @objc func updateArcanaView() {
        getArcanaView()
        reloadView()
    }
    
    func reloadView() {
        
        setupColumns()
        arcanaCountView.setText(text: "아르카나 수 \(arcanaArray.count)")
        
        if traitCollection.horizontalSizeClass == .compact {
            
            switch arcanaView {
                
            case .list, .main:
                tableView.isScrollEnabled = true
                collectionView.isScrollEnabled = false
                if arcanaArray.count == 0 {
                    tableView.alpha = 0
                }
                else {
                    collectionView.alpha = 0
                    tableView.reloadData()
                    if tableView.alpha == 0 {
                        tableView.fadeIn(withDuration: 0.5)
                    }
                }
                
            case .profile, .mainGrid:
                tableView.isScrollEnabled = false
                collectionView.isScrollEnabled = true
                if arcanaArray.count == 0 {
                    collectionView.alpha = 0
                }
                else {
                    tableView.alpha = 0
                    collectionView.reloadData()
                    if collectionView.alpha == 0 {
                        collectionView.fadeIn(withDuration: 0.5)
                    }
                }
                
            }

        }
            
        else {
            tableView.isScrollEnabled = false
            collectionView.isScrollEnabled = true
            if arcanaArray.count == 0 {
                collectionView.alpha = 0
            }
            else {
                tableView.alpha = 0
                collectionView.reloadData()
                collectionView.fadeIn(withDuration: 0.5)
            }

        }
        
        if arcanaArray.count == 0 {
            tipLabel.fadeIn(withDuration: 0.5)
        }
        else {
            tipLabel.fadeOut(withDuration: 0.2)
        }
        
    }
    
    func reloadIndexPathAt(_ index: Int) {
        
        var indexPath: IndexPath
        if traitCollection.horizontalSizeClass == .compact {
            
            switch arcanaView {
                
            case .list, .main:
                if arcanaView == .list {
                    indexPath = IndexPath(row: 0, section: index)
                }
                else {
                    indexPath = IndexPath(row: 1, section: index)
                }
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.endUpdates()

            case .profile, .mainGrid:
                indexPath = IndexPath(item: index, section: 0)

                collectionView.performBatchUpdates({
                    self.collectionView.reloadItems(at: [indexPath])
                }, completion: nil)

            }
            
            
        }
        else {
            indexPath = IndexPath(item: index, section: 0)
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: [indexPath])
            }, completion: nil)

        }
        
    }
    
    func insertIndexPathAt(index: Int) {

        let indexSet = IndexSet(integer: index)

        if traitCollection.horizontalSizeClass == .compact {
            switch arcanaView {
                
            case .list, .main:
                tableView.beginUpdates()
                tableView.insertSections(indexSet, with: .automatic)
                tableView.endUpdates()
                
            case .profile, .mainGrid:
                collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                }, completion: nil)
            }

        }
        else {
            collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }, completion: nil)
        }
    }
    
    func deleteIndexPathAt(index: Int) {
        
        let indexSet = IndexSet(integer: index)

        if traitCollection.horizontalSizeClass == .compact {
            switch arcanaView {
                
            case .list, .main:
                tableView.beginUpdates()
                tableView.deleteSections(indexSet, with: .automatic)
                tableView.endUpdates()
                
            case .profile, .mainGrid:
                collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }, completion: nil)
            }

        }
        else {
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }, completion: nil)
        }
        
    }
    
    func downloadArcana() {
        
    }
    
    private func sortArcanaByName() {
        arcanaArray = arcanaArray.sorted(by: {($0.getNameKR()) < ($1.getNameKR())})
        reloadView()
    }
    
    private func sortArcanaByRecent() {
        arcanaArray = arcanaArray.sorted(by: {($0.getUID()) > ($1.getUID())})
        reloadView()
    }
    
    private func sortArcanaByNumberOfViews() {
        arcanaArray = arcanaArray.sorted(by: {($0.getNumberOfViews()) > ($1.getNumberOfViews())})
        reloadView()
    }

    @objc func sort(_ sender: AnyObject) {
        
        guard let button = sender as? UIView else { return }
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = Color.salmon
        alertController.setValue(NSAttributedString(string:
            "정렬", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.black]), forKey: "attributedTitle")
        
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
    
    @objc func toggleFilterView() {
        showFilter = !showFilter
    }
    
//    func toggleArcanaView() {
//        switch arcanaView {
//        case .list:
//            arcanaView = .main
//        case .main:
//            arcanaView = .profile
//        case .profile:
//            arcanaView = .mainGrid
//        case .mainGrid:
//            arcanaView = .list
//        }
//    }

    @objc func dismissFilter() {

        // If filter is open and user presses on left column, dismiss filter.
        if showFilter && gesture.location(in: self.view).x < 95 {
            gesture.cancelsTouchesInView = true
            showFilter = false
        }
        else {
            gesture.cancelsTouchesInView = false
        }
        
    }

    func getArcanaView() {
        
        switch arcanaVC {
            
        case .search:
            if let userPref = defaults.getSearchView(), let arcanaView = ArcanaView(rawValue: userPref) {
                if self.arcanaView != arcanaView {
                    self.arcanaView = arcanaView
                }
            }
        case .tavern:
            if let userPref = defaults.getTavernView(), let arcanaView = ArcanaView(rawValue: userPref) {
                if self.arcanaView != arcanaView {
                    self.arcanaView = arcanaView
                }
            }
        case .favorites:
            if let userPref = defaults.getFavoritesView(), let arcanaView = ArcanaView(rawValue: userPref) {
                if self.arcanaView != arcanaView {
                    self.arcanaView = arcanaView
                }
            }
        }
    }
}


extension ArcanaViewController: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        switch arcanaView {
        case .list, .main:
            guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
            
            let arcana: Arcana
            arcana = arcanaArray[indexPath.section]
            
            let vc = ArcanaPeekPreview(arcana: arcana)
            vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            
            return vc
            
            
        case .profile, .mainGrid:
            guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
            
            let arcana: Arcana
            arcana = arcanaArray[indexPath.item]
            
            let vc = ArcanaPeekPreview(arcana: arcana)
            vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)
            if let frame = collectionView.cellForItem(at: indexPath)?.frame {
                previewingContext.sourceRect = frame
            }
            
            return vc
            
        }

    }
    
}

extension ArcanaViewController: FilterDelegate {
    
    func didUpdate(_ sender: FilterViewController) {
        
        DispatchQueue.main.async {
            
            self.filters = sender.filterTypes
            
            if sender.hasFilter == false {
                self.arcanaArray = self.originalArray
                self.reloadView()
            }
                
            else {
                
                var raritySet: Set<Arcana>?
                if let r = self.filters["rarity"] {
                    
                    for rarity in r {
                        
                        
                        let filteredRarity = Set(self.originalArray.filter({$0.getRarity() == rarity}))
                        if let _ = raritySet {
                            raritySet = raritySet?.union(filteredRarity)
                        }
                        else {
                            raritySet = filteredRarity
                        }
                    }
                    
                }
                
                
                var groupSet: Set<Arcana>?
                if let g = self.filters["group"] {
                    
                    for group in g {
                        
                        let filteredGroup = Set(self.originalArray.filter({$0.getGroup() == group}))
                        
                        if let _ = groupSet {
                            groupSet = groupSet?.union(filteredGroup)
                        }
                        else {
                            groupSet = filteredGroup
                        }
                        
                    }
                    
                }
                
                var weaponSet: Set<Arcana>?
                if let w = self.filters["weapon"] {
                    
                    for weapon in w {
                        
                        let filteredWeapon = Set(self.originalArray.filter({$0.getWeapon()[$0.getWeapon().startIndex] == weapon[weapon.startIndex]}))
                        
                        if let _ = weaponSet {
                            weaponSet = groupSet?.union(filteredWeapon)
                        }
                        else {
                            weaponSet = filteredWeapon
                        }
                        
                    }
                    
                }
                
                var affiliationSet: Set<Arcana>?
                if let a = self.filters["affiliation"] {
                    
                    for affiliation in a {
                        
                        let filteredAffiliation = Set(self.originalArray.filter({$0.getAffiliation() != nil && $0.getAffiliation()!.contains(affiliation)}))
                        
                        if let _ = affiliationSet {
                            affiliationSet = groupSet?.union(filteredAffiliation)
                        }
                        else {
                            affiliationSet = filteredAffiliation
                        }
                    }
                    
                }
                
                let sets = ["rarity" : raritySet, "group" : groupSet, "weapon" : weaponSet, "affiliation" : affiliationSet]
                
                var finalFilter: Set = Set<Arcana>()
                for (_,value) in sets {
                    
                    // If the filter was selected, it will NOT be optional
                    if let filter = value {
                        
                        if filter.count == 0 {
                            // One filter had no matches, so show no results.
                            finalFilter = Set<Arcana>()
                            break
                            
                        }
                        else {
                            // if set is empty, create a new one
                            if finalFilter.count == 0 {
                                finalFilter = finalFilter.union(filter)
                            }
                                
                                // Set already exists, so intersect
                            else {
                                finalFilter = finalFilter.intersection(filter)
                            }
                        }
                    }
                    
                }
                
                let filteredArray = Array(finalFilter).sorted(by: {($0.getUID()) > ($1.getUID())})
                self._arcanaArray = filteredArray
                self.reloadView()
                
            }

        }
        
    }
}
