//
//  ArcanaDetail.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView
import FirebaseAnalytics

enum ArcanaButton {
    case heart
    case favorite
}

protocol ArcanaDetailProtocol : class {
    func toggleHeart(_ cell: ArcanaButtonsCell)
    func toggleFavorite(_ cell: ArcanaButtonsCell)
}

class ArcanaDetail: HideBarsViewController, UIScrollViewDelegate {
    
    let arcana: Arcana
    weak var presentingDelegate: LoadingArcanaViewController?
    
    lazy var arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = UIScreen.main.bounds
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedSectionHeaderHeight = 20
        tableView.sectionFooterHeight = 0
//        tableView.estimatedRowHeight = 160
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = .groupTableViewBackground
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero
        
        tableView.register(ArcanaImageCell.self, forCellReuseIdentifier: "ArcanaImageCell")
        tableView.register(ArcanaBaseInfoCollectionView.self, forCellReuseIdentifier: "ArcanaBaseInfoCollectionView")
        tableView.register(ArcanaAttributeCell.self, forCellReuseIdentifier: "ArcanaAttributeCell")
        tableView.register(ArcanaClassCell.self, forCellReuseIdentifier: "ArcanaClassCell")
        tableView.register(ArcanaSkillCell.self, forCellReuseIdentifier: "ArcanaSkillCell")
        tableView.register(ArcanaSkillAbilityDescCell.self, forCellReuseIdentifier: "ArcanaSkillAbilityDescCell")
        tableView.register(ArcanaChainStoryCell.self, forCellReuseIdentifier: "ArcanaChainStoryCell")
        tableView.register(ArcanaViewEditsCell.self, forCellReuseIdentifier: "ArcanaViewEditsCell")
        
        return tableView
    }()
    
    var heart = false
    var favorite = false
    var imageTapped = false
    
    lazy var tapShowBarGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBars))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        return tap
    }()
    
    lazy var tapImageGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        return tap
    }()
    
    override var prefersStatusBarHidden: Bool {
        if navigationController?.isNavigationBarHidden == true {
            return true
        }
        else {
            return false
        }
    }
    
    init(arcana: Arcana) {
        self.arcana = arcana
        print("ARCANAID: \(arcana.getUID())")
        super.init(nibName: nil, bundle: nil)
        setupNavBar()

    }
    
    init(arcana: Arcana, site: Bool) {
        self.arcana = arcana
        print("ARCANAID: \(arcana.getUID())")
        super.init(nibName: nil, bundle: nil)
        setupNavBarModal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateHistory()
        setupViews()
        checkFavorites()
    }
    @objc 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        if let _ = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("TavernArcanaView", screenClass: nil)

        if let bundleID = Bundle.main.bundleIdentifier {
            if bundleID != "com.jk.cckorea.debug" {
                let dataRequest = FirebaseService.dataRequest
                dataRequest.incrementCount(ref: ARCANA_REF.child(arcana.getUID()).child("numberOfViews"))
            }
        }
//        if !defaults.hasViewedSurvey() && defaults.getArcanaDetailViewCount() > 10 && defaults.getAppLaunchCount() > 10 {
//            showSurvey()
//        }
//        showSurvey()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        
        arcanaImageView.removeFromSuperview()
        tableView.removeFromSuperview()
        view.addSubview(tableView)
        
        if traitCollection.horizontalSizeClass == .compact {
            updateCompactViews()
        } else {
            updateRegularViews()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBars()
    }
        
    func setupViews() {

        title = arcana.getNameKR()
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)

        if traitCollection.horizontalSizeClass == .compact {
            updateCompactViews()
        }
        else {
            updateRegularViews()
        }

    }
    
    func updateCompactViews() {
        
        view.backgroundColor = .white
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            tableView.addGestureRecognizer(tapShowBarGesture)
        }

        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let constant: CGFloat
        if let hidden = navigationController?.isNavigationBarHidden, hidden == true {
            constant = 50
        }
        else {
            constant = 0
        }
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: constant)
        tableViewBottomConstraint?.isActive = true
        
        arcanaImageView.removeFromSuperview()
    }
    
    func updateRegularViews() {
        
        view.backgroundColor = .groupTableViewBackground
        
        view.addSubview(arcanaImageView)
                
        arcanaImageView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: view.frame.width/2, heightConstant: (view.frame.width/2)*1.5)
        arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, sender: nil)
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: arcanaImageView.trailingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if traitCollection.horizontalSizeClass == .compact {
//            print("COMPACT")
//        }
//        tableView.reloadData()
//    }
//
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        arcanaImageView.removeFromSuperview()
        tableView.reloadData()
    }
    
    func setupNavBar() {
        
        let shareButton = UIButton(type: .custom)
        
        shareButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        shareButton.addTarget(self, action: #selector(exportArcana), for: .touchUpInside)
        shareButton.setImage(#imageLiteral(resourceName: "export"), for: .normal)
        
        let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        shareBarButton.customView = shareButton
        
        let editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        editButton.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        editBarButton.customView = editButton
        
        navigationItem.rightBarButtonItems = [editBarButton, shareBarButton]

    }
    
    func setupNavBarModal() {
        
        let closeButton = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = closeButton
        
        let shareButton = UIButton(type: .custom)
        
        shareButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        shareButton.addTarget(self, action: #selector(exportArcana), for: .touchUpInside)
        shareButton.setImage(#imageLiteral(resourceName: "export"), for: .normal)
        
        let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        shareBarButton.customView = shareButton
        
        let editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        editButton.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        editBarButton.customView = editButton
        
        navigationItem.rightBarButtonItems = [editBarButton, shareBarButton]
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: {
            self.presentingDelegate?.dismiss(animated: true, completion: nil)
        })
    }

    
    @objc func exportArcana() {
        
        if imageTapped == true {
            
            imageTapped = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.imageScrollView.removeFromSuperview()
            })
        }
        
        let alertController = UIAlertController(title: "앨범에 저장", message: "화면을 캡쳐하겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 10
        
        let save = UIAlertAction(title: "확인", style: .default, handler: { action in
            
            DispatchQueue.main.async {
                self.screenShot()
            }
            
            Analytics.logEvent("ExportedArcana", parameters: [
                "name": self.arcana.getNameKR() as NSObject,
                "arcanaID": self.arcana.getUID() as NSObject
                ])
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true) {
            alertController.view.tintColor = Color.salmon
        }
        
    }
    
    func screenShot() {
        
        let savedContentOffset = tableView.contentOffset
        tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections-1), at: .bottom, animated: false)
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0)

//        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)

        guard let context = UIGraphicsGetCurrentContext() else { return }
        tableView.layer.render(in: context)
        
        for i in 0 ..< tableView.numberOfSections  {
            if tableView.numberOfRows(inSection: i) > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: i), at: .bottom, animated: false)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                tableView.layer.render(in: context)
            }
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        UIGraphicsEndImageContext()
        tableView.contentOffset = savedContentOffset
    }

    func updateHistory() {
        var recents = [String]()
        
        let uid = arcana.getUID()
        recents = defaults.getRecent()
        
        if recents.count == 0 {
            recents.append(uid)
        }
            
        else {
            var found = false
            for (index, search) in recents.enumerated() {
                if uid == search {
                    recents.remove(at: index)
                    recents.append(uid)
                    found = true
                    break
                }
            }
            
            if found == false {
                
                if recents.count >= 5 {
                    recents.remove(at: 0)
                    recents.append(uid)
                }
                    
                else {
                    recents.append(uid)
                }
            }
        }
        defaults.setRecent(value: recents)
        defaults.set(recents, forKey: "recent")
    
    }

    @objc func edit() {
        
        if defaults.canEdit() {
            let vc = ArcanaDetailEdit(arcana: arcana)
            navigationController?.pushViewController(vc, animated: true)
            Analytics.logEvent("TappedEditArcana", parameters: [
                "name": self.arcana.getNameKR() as NSObject,
                "arcanaID": self.arcana.getUID() as NSObject
                ])
            
        }
        else {
            showAlert(title: "권한 없음", message: "로그인하면 수정할 수 있습니다.")
        }
    }
    
    func checkFavorites() {
        // TODO: when favoriting, automatically like. when cancelling, only cancel one.
        
        guard let uid = defaults.getUID() else { return }
        let favRef = FIREBASE_REF.child("user/\(uid)/favorites/\(arcana.getUID())")
        let heartRef = FIREBASE_REF.child("user/\(uid)/likes/\(arcana.getUID())")
        favRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                self.favorite = true
            }

        })
        
        heartRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                self.heart = true
            }
        })
        
    }
   
    func getRarityLong(_ string: String) -> String {
        
        switch string {
            
        case "5★", "5":
            return "SSR ★ 5"
        case "4★", "4":
            return "SR ★ 4"
        case "3★", "3":
            return "R ★ 3"
        case "2★", "2":
            return "HN ★ 2"
        case "1★", "1":
            return "N ★ 1"
        default:
            return "업데이트 필요"
        }
        
    }
    
    @objc func tappedImage() {
        
        if imageTapped == false {
            
            imageTapped = true

            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ArcanaImageCell, cell.imageLoaded else { return }
            
            imageScrollView.setZoomScale(1, animated: false)

            backgroundView.frame = imageScrollView.frame
            backgroundView.fadeIn(withDuration: 0.5)
            backgroundView.addSubview(arcanaImageView)
            
            arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, sender: cell)
            arcanaImageView.frame = backgroundView.frame
            arcanaImageView.fadeIn()
            
            imageScrollView.addSubview(backgroundView)
            
            view.window?.addSubview(imageScrollView)
            
            addGestures(backgroundView)
            
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundView
    }

    func addGestures(_ sender: UIView) {
        
        let closeImage = UITapGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        sender.addGestureRecognizer(closeImage)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeDown.direction = .down
        sender.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeUp.direction = .up
        sender.addGestureRecognizer(swipeUp)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeRight.direction = .right
        sender.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeLeft.direction = .left
        sender.addGestureRecognizer(swipeLeft)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exportArcana))
        sender.addGestureRecognizer(longPress)
    }
    
    @objc func dismissImage(_ gesture: UIGestureRecognizer) {
        
        // gesture view is the background view for the image
        guard let gestureView = gesture.view else {
            return
        }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                gestureView.alpha = 0
                
                switch swipeGesture.direction {
                    
                case UISwipeGestureRecognizerDirection.up:
                    gestureView.frame = CGRect(x: gestureView.frame.origin.x, y: -(gestureView.frame.size.height), width: gestureView.frame.size.width, height: gestureView.frame.size.height)
                    
                case UISwipeGestureRecognizerDirection.left:
                    gestureView.frame = CGRect(x: -(gestureView.frame.size.width), y: 0, width: gestureView.frame.size.width, height: 0)
                    
                case UISwipeGestureRecognizerDirection.right:
                    gestureView.frame = CGRect(x: gestureView.frame.size.width, y: 0, width: gestureView.frame.size.width, height: 0)
                    
                case UISwipeGestureRecognizerDirection.down:
                    gestureView.frame = CGRect(x: gestureView.frame.origin.x, y: self.view.frame.height, width: gestureView.frame.size.width, height: gestureView.frame.size.height)
                default:
                    break
                }
                
                }) {_ in

                    self.imageScrollView.removeFromSuperview()
            }
            
        }
        
        else {
            UIView.animate(withDuration: 0.2, animations: {
                gestureView.alpha = 0
                self.imageScrollView.removeFromSuperview()

            })
        }
        
        imageTapped = false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        // cancel tap gesture if user is taps the image, selects a button, or calls didSelect.
        if gestureRecognizer == tapShowBarGesture {

            let location = touch.location(in: tableView)
            
            if location.x < 25 {
                return false
            }
            
            if let indexPath = tableView.indexPathForRow(at: location) {
                
                if let _ = tableView.cellForRow(at: indexPath) as? ArcanaImageCell {
                    return false
                }
                if let _ = tableView.cellForRow(at: indexPath) as? ArcanaViewEditsCell {
                    return false
                }
            }

            if touch.view!.isKind(of: UIButton.self) {
                return false
            }
        }

        return true
    }
    
    func showSurvey() {
        
        let popup = RatePopupView()
        popup.arcanaDetailDelegate = self
        view.addSubview(popup)
        
        popup.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 20, widthConstant: 0, heightConstant: 0)
        
        popup.transform = .init(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            popup.transform = .identity
        }, completion: nil )
        
    }
}

// MARK - UITableViewDelegate, UITableViewDataSource
extension ArcanaDetail: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case image
        case attribute
        case skill
        case ability
        case kizuna
        case chainStory
        case wikiJP
        case edit
    }
    
    private enum SkillRow: Int {
        case skill1
        case skill2
        case skill3
    }
    
    private enum AbilityRow: Int {
        case ability1
        case ability2
        case partyAbility
    }
    
    private enum ChainStoryRow: Int {
        case chainStory
        case chainStone
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .image:
            if traitCollection.horizontalSizeClass == .compact {
                return 1
            }
            else {
                return 0
            }
        case .attribute:
            return 1
        case .skill:
            
            // Returning 2 * skillCount for description.
            switch arcana.getSkillCount() {
            case "1":
                return 1
            case "2":
                return 2
            case "3":
                return 3
            default:
                return 1
            }
            
        case .ability:
            
            if let _ = arcana.getPartyAbility() {
                return 3
            }
            else if let _ = arcana.getAbilityName3() {  // 리제 롯데
                return 3
            }
            else if let _ = arcana.getAbilityName2() {  // has 2 abilities
                return 2
            }
            else if let _ = arcana.getAbilityName1() {  // has only 1 ability
                return 1
            }
            else {
                return 0
            }
            
        case .kizuna:
            return 1
            
        case .chainStory:
            var count = 0
            if let _ = arcana.getChainStory() {
                count += 1
            }
            if let _ = arcana.getChainStone() {
                count += 1
            }
            
            return count
            
        case .wikiJP:
            return 1
        case .edit:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .image:
            if traitCollection.horizontalSizeClass == .compact {
                return tableView.frame.width * 1.5
            }
            else {
                return 0
            }
        case .attribute:
            return 382
            
        default:
            return UITableViewAutomaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
        switch section {
            
        case .image:
            if traitCollection.horizontalSizeClass == .compact {
                return tableView.frame.width * 1.5
            }
            else {
                return 0
            }
        case .attribute:
            return 382
            
        default:
            return UITableViewAutomaticDimension
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.numberOfRows(inSection: section) != 0 {
            guard let section = Section(rawValue: section) else { return 0 }
            
            switch section {
            case .image, .attribute:
                return CGFloat.leastNonzeroMagnitude
            default:
                return 20
            }
        }
        
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .image:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaImageCell") as! ArcanaImageCell
            cell.selectionStyle = .none
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                cell.arcanaImage.addGestureRecognizer(tapImageGesture)
            }
            cell.activityIndicator.startAnimating()
            
            cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .main, sender: cell)

            return cell
            
        case .attribute:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaBaseInfoCollectionView") as! ArcanaBaseInfoCollectionView
            cell.arcana = arcana
            cell.arcanaDetailDelegate = self
            cell.selectionStyle = .none
            cell.collectionView.reloadData()

            return cell
            
        case .skill:
            
            guard let row = SkillRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillCell") as! ArcanaSkillCell
            cell.selectionStyle = .none
            
            switch row {
                
            case .skill1:
                cell.skillNumberLabel.text = "스킬 1"
                cell.skillManaLabel.text = "\(arcana.getSkillMana1()) 마나"
                cell.skillDescLabel.text = arcana.getSkillDesc1()
            case .skill2:
                cell.skillNumberLabel.text = "스킬 2"
                let skillMana2 = arcana.getSkillMana2() ?? "1"
                cell.skillManaLabel.text = skillMana2 + " 마나"
                cell.skillDescLabel.text = arcana.getSkillDesc2()
            case .skill3:
                cell.skillNumberLabel.text = "스킬 3"
                let skillMana3 = arcana.getSkillMana3() ?? "1"
                cell.skillManaLabel.text = skillMana3 + " 마나"
                cell.skillDescLabel.text = arcana.getSkillDesc3()
            }
            
            cell.skillDescLabel.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case .ability:
            
            guard let row = AbilityRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
            cell.selectionStyle = .none
            
            switch row {
            case .ability1:
                cell.attributeKeyLabel.text = "어빌 1"
                cell.attributeValueLabel.text = arcana.getAbilityDesc1()
            case .ability2:
                cell.attributeKeyLabel.text = "어빌 2"
                cell.attributeValueLabel.text = arcana.getAbilityDesc2()
                
            case .partyAbility:
                if let _ = arcana.getPartyAbility() {
                    cell.attributeKeyLabel.text = "파티 어빌"
                    cell.attributeValueLabel.text = arcana.getPartyAbility()
                }
                else {
                    // 리제 롯데
                    cell.attributeKeyLabel.text = "어빌 3"
                    cell.attributeValueLabel.text = arcana.getAbilityDesc3()
                }
            }
            
            cell.attributeValueLabel.setLineHeight(lineHeight: 1.2)
            //            cell.attributeValueLabel.layoutIfNeeded()
            return cell
            
        case .kizuna:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillCell") as! ArcanaSkillCell
            cell.selectionStyle = .none
            
            cell.skillNumberLabel.text = "인연"
            cell.skillManaLabel.text = "코스트 \(arcana.getKizunaCost())"
            cell.skillDescLabel.text = arcana.getKizunaDesc()
            
            cell.skillDescLabel.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case .chainStory:
            
            guard let row = ChainStoryRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
            cell.selectionStyle = .none
            
            switch row {
                
            case .chainStory:
                if let cStory = arcana.getChainStory() {
                    cell.attributeKeyLabel.text = "체인스토리"
                    cell.attributeValueLabel.text = cStory
                    return cell
                } else if let cStone = arcana.getChainStone() {
                    cell.attributeKeyLabel.text = "정령석 보상"
                    cell.attributeValueLabel.text = cStone
                }
                
            case .chainStone:
                if let cStone = arcana.getChainStone() {
                    cell.attributeKeyLabel.text = "정령석 보상"
                    cell.attributeValueLabel.text = cStone
                }
            }
            
            return cell
            
        case .wikiJP:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaViewEditsCell") as! ArcanaViewEditsCell
            cell.editLabel.text = "일첸 위키 가기"
            cell.arrow.image = #imageLiteral(resourceName: "go")
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        case .edit:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaViewEditsCell") as! ArcanaViewEditsCell
            cell.editLabel.text = "편집 기록 보기"
            cell.arrow.image = #imageLiteral(resourceName: "go")
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .wikiJP:
            
            let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"

            var arcanaURL = ""
            if let nicknameJP = arcana.getNicknameJP() {
                arcanaURL = nicknameJP + arcana.getNameJP()
            }
            else {
                arcanaURL = arcana.getNameJP()
            }
            guard let encodedURL = arcanaURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed), let url = URL(string: (baseURL + encodedURL)) else { return }
            let vc = LinkViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        case .edit:
            let vc = ArcanaEditList(arcanaID: arcana.getUID())
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        

    }

}

extension ArcanaDetail: ArcanaDetailProtocol {
    
    func toggleHeart(_ cell: ArcanaButtonsCell) {
        
        var userInfo = defaults.getLikes()
        guard let userID = defaults.getUID() else { return }
        
        let ref = FIREBASE_REF.child("user/\(userID)/likes/\(arcana.getUID())")
        
        var found = false
        
        for (index, id) in userInfo.enumerated().reversed() {
            if id == arcana.getUID() {
                userInfo.remove(at: index)
                ref.removeValue()
                found = true
                break
            }
        }
        
        if found == false {
            // add to array
            userInfo.append(arcana.getUID())
            ref.setValue(true)
            FirebaseService.dataRequest.incrementLikes(uid: arcana.getUID(), increment: true)
            if let currentLikes = cell.numberOfLikesLabel.text, let count = Int(currentLikes) {
                cell.numberOfLikesLabel.text = "\(count + 1)"
            }
            
        }
        else {
            FirebaseService.dataRequest.incrementLikes(uid: arcana.getUID(), increment: false)
            if let currentLikes = cell.numberOfLikesLabel.text, let count = Int(currentLikes), count > 0{
                cell.numberOfLikesLabel.text = "\(count - 1)"
            }
        }
        
        
        defaults.setLikes(value: userInfo)
        
        
    }
    
    func toggleFavorite(_ cell: ArcanaButtonsCell) {
        
        var userInfo = defaults.getFavorites()
        guard let userID = defaults.getUID() else { return }
        
        let ref = FIREBASE_REF.child("user/\(userID)/favorites/\(arcana.getUID())")
        
        var found = false
        
        for (index, id) in userInfo.enumerated().reversed() {
            if id == arcana.getUID() {
                userInfo.remove(at: index)
                ref.removeValue()
                found = true
                break
            }
        }
        
        if found == false {
            // add to array
            userInfo.append(arcana.getUID())
            ref.setValue(true)
        }
        
        defaults.setFavorites(value: userInfo)
        
        
    }
    
}

