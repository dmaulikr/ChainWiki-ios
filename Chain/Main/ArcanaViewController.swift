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
    var filterViewController: Filter?

    var arcanaArray = [Arcana]()
    var originalArray = [Arcana]()
    var filters = [String: [String]]()
    var initialLoad = true

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alpha = 0
        tableView.estimatedRowHeight = 90
        tableView.estimatedSectionHeaderHeight = 50
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
        navigationItem.title = "홈"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ref.removeAllObservers()
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

//        filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: nil, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
//        filterViewLeadingConstraint = filterView.leadingAnchor.constraint(equalTo: view.trailingAnchor)
//        filterViewLeadingConstraint?.isActive = true
        
        filterView.anchor(top: topLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 225, heightConstant: 0)
        
        setupChildViews()

    }
    
    func setupChildViews() {
        
        // Setup FilterView
        filterViewController = Filter()
        
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
        
        
        // Pan Filter gesture
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        view.addGestureRecognizer(panGesture)
    }
    
    let pannableFrame = CGRect(x: 100, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
    
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        let translation = gestureRecognizer.translation(in: self.view)

        switch gestureRecognizer.state {

        case .began, .changed:

            if !showFilter {
                showFilter = true
            }
            
            if !pannableFrame.contains(gestureRecognizer.location(in: view)) {
                
            }
            
            if gestureRecognizer.velocity(in: view).x < 0 {
                if filterView.center.x >= (SCREENWIDTH+100)/2 {
                    filterView.center = CGPoint(x: filterView.center.x + translation.x, y: filterView.center.y)
                    gestureRecognizer.setTranslation(CGPoint.zero, in: filterView)
                }
                else {
                    return
                    
                }
            }
            else {
                print("positive")
                if filterView.center.x >= (SCREENWIDTH+100)/2 && filterView.center.x < (SCREENWIDTH * 1.5){
//                if filterView.frame.minX < SCREENWIDTH {
                    filterView.center = CGPoint(x: filterView.center.x + translation.x, y: filterView.center.y)
                    gestureRecognizer.setTranslation(CGPoint.zero, in: filterView)
                }
                else {
                    return
                }
            }

        case .ended:
            if filterView.frame.minX < 100 {
                filterView.center = CGPoint(x: (SCREENWIDTH + 100)/2, y: filterView.center.y)
//                gestureRecognizer.setTranslation(CGPoint.zero, in: filterView)
            }
        default:
            break
        }


    }
    
    func reloadTableView() {
        if arcanaArray.count == 0 {
            tableView.alpha = 0
            tipLabel.fadeIn(withDuration: 0.5)
            
        }
        else {
            tableView.reloadData()
            tipLabel.fadeOut(withDuration: 0.2)
            tableView.fadeIn(withDuration: 0.5)
        }
    }
    
    func downloadArcana() {
        
    }
    
    private func sortArcanaByName() {
        arcanaArray = arcanaArray.sorted(by: {($0.getNameKR()) < ($1.getNameKR())})
        reloadTableView()
    }
    
    private func sortArcanaByRecent() {
        arcanaArray = arcanaArray.sorted(by: {($0.getUID()) > ($1.getUID())})
        reloadTableView()
    }
    
    private func sortArcanaByNumberOfViews() {
        arcanaArray = arcanaArray.sorted(by: {($0.getNumberOfViews()) > ($1.getNumberOfViews())})
        reloadTableView()
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

extension ArcanaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if arcanaArray.count > 0 {
            return AbilitySectionHeader(sectionTitle: "아르카나 수 \(arcanaArray.count)")
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
        cell.arcanaNickKR.text = nil
        cell.arcanaNickJP.text = nil
        cell.arcanaImage.image = nil
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.row]
        
        cell.arcanaID = arcana.getUID()
        cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .icon, sender: cell)
        
        // check if arcana has only name, or nickname.
        if let nnKR = arcana.getNicknameKR() {
            cell.arcanaNickKR.text = nnKR
        }
        if let nnJP = arcana.getNicknameJP() {
            cell.arcanaNickJP.text = nnJP
        }
        cell.arcanaNameKR.text = arcana.getNameKR()
        cell.arcanaNameJP.text = arcana.getNameJP()
        
        cell.arcanaRarity.text = "#\(arcana.getRarity())★"
        cell.arcanaGroup.text = "#\(arcana.getGroup())"
        cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
        
        if let a = arcana.getAffiliation() {
            if a != "" {
                cell.arcanaAffiliation.text = "#\(a)"
            }
            
        }
        cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        let arcana: Arcana
        arcana = arcanaArray[row]
        
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
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        let arcana: Arcana
        arcana = arcanaArray[indexPath.row]
        
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
                self.arcanaArray = self.originalArray
                self.reloadTableView()
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
                self.arcanaArray = filteredArray
                self.reloadTableView()
                
            }
            
        }
    }
}
