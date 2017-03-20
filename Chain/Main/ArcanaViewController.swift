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
//    var arcanaRefHandle: FIRDatabaseHandle?
    
//    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    var filters = [String: [String]]()
    var initialLoad = true
    
    var arcanaDataSource: ArcanaDataSource? = ArcanaDataSource([Arcana]()) {
        didSet {
            tableView.dataSource = arcanaDataSource
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.alpha = 0
        tableView.estimatedRowHeight = 90
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        
        return tableView
    }()

    let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()

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
        navigationItem.title = "홈"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        arcanaDataSource = nil
        ref.removeAllObservers()
        print("deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(tipLabel)
        view.addSubview(filterView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tipLabel.anchorCenterSuperview()

        filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
        
        setupChildViews()

    }
    
    func setupChildViews() {
        
        // Setup FilterView
        let filterMenu = Filter()
        filterMenu.delegate = self
        
        addChildViewController(filterMenu)
        
        filterView.addSubview(filterMenu.view)
        filterMenu.view.frame = filterView.frame
        
        filterMenu.didMove(toParentViewController: self)

    }

    func setupNavBar() {
        
        let filter = UIButton()
        filter.setImage(UIImage(named: "filter.png"), for: .normal)
        filter.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filter.addTarget(self, action: #selector(toggleFilterView), for: .touchUpInside)
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
    
    func downloadArcana() {
        
    }
    
    private func sortArcanaByName() {
        guard let arcanaDataSource = arcanaDataSource else { return }
        let array = arcanaDataSource.arcanaArray.sorted(by: {($0.getNameKR()) < ($1.getNameKR())})
        self.arcanaDataSource = ArcanaDataSource(array)
    }
    
    private func sortArcanaByRecent() {
        guard let arcanaDataSource = arcanaDataSource else { return }
        let array = arcanaDataSource.arcanaArray.sorted(by: {($0.getUID()) > ($1.getUID())})
        self.arcanaDataSource = ArcanaDataSource(array)
    }
    
    private func sortArcanaByNumberOfViews() {
        guard let arcanaDataSource = arcanaDataSource else { return }
        let array = arcanaDataSource.arcanaArray.sorted(by: {($0.getNumberOfViews()) > ($1.getNumberOfViews())})
        self.arcanaDataSource = ArcanaDataSource(array)
    }

    func sort(_ sender: AnyObject) {
        
        guard let button = sender as? UIView else { return }
        
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
    
    func toggleFilterView() {
        showFilter = !showFilter
    }

    func dismissFilter() {

        // If filter is open and user presses on left column, dismiss filter.
        if showFilter && gesture.location(in: self.view).x < 95 {
            gesture.cancelsTouchesInView = true
            showFilter = false
        }
        else {
            gesture.cancelsTouchesInView = false
        }
        
        
    }

}

extension ArcanaViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = tableView.indexPathForSelectedRow?.row, let arcanaDataSource = arcanaDataSource else { return }
        
        let arcana: Arcana
        arcana = arcanaDataSource.arcanaArray[row]
        
        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ArcanaViewController: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location), let arcanaDataSource = arcanaDataSource else { return nil }
        
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        let arcana: Arcana
        arcana = arcanaDataSource.arcanaArray[indexPath.row]
        
        let vc = ArcanaPeekPreview(arcana: arcana)
        vc.preferredContentSize = CGSize(width: 0, height: view.frame.height)

        return vc
    }
    
}

extension ArcanaViewController: FilterDelegate {
    
    func didUpdate(_ sender: Filter) {
        DispatchQueue.main.async {
            
            self.filters = sender.filterTypes
            
            if sender.hasFilter == false {
                self.arcanaDataSource = ArcanaDataSource(self.originalArray)
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
                
                self.arcanaDataSource = ArcanaDataSource(Array(finalFilter))
                guard let arcanaDataSource = self.arcanaDataSource else { return }
                if arcanaDataSource.arcanaArray.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                
            }
            
        }
    }
}
