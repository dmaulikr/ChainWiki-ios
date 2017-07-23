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
//import Hero

enum ArcanaButton {
    case heart
    case favorite
}

protocol ArcanaDetailProtocol : class {
    func toggleHeart(_ cell: ArcanaButtonsCell)
    func toggleFavorite(_ cell: ArcanaButtonsCell)
}

class ArcanaDetail: HideBarsViewController, UIScrollViewDelegate {
    
    var arcana: Arcana
    var initialLoad = true
    weak var presentingDelegate: LoadingArcanaViewController?
//    var tableViewBottomConstraint: NSLayoutConstraint?
    var panDismissGesture: UIPanGestureRecognizer!
    var arcanaSection: ArcanaSection?
    
    lazy var arcanaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0
//        if #available(iOS 11.0, *) {
//            customEnableDropping(on: imageView, dropInteractionDelegate: self)
//        }
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
    
    let animatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: Color.lightGreen, padding: 0)
        return spinner
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
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.bounces = false
        tableView.backgroundColor = .groupTableViewBackground
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero
        
        tableView.register(UINib(nibName: "ArcanaMainImageViewWrapperCell", bundle: nil), forCellReuseIdentifier: "ArcanaMainImageViewWrapperCell")
        tableView.register(ArcanaImageCell.self, forCellReuseIdentifier: "ArcanaImageCell")
        tableView.register(UINib(nibName: "ArcanaNameCell", bundle: nil), forCellReuseIdentifier: "ArcanaNameCell")
        tableView.register(UINib(nibName: "ArcanaBaseInfoCell", bundle: nil), forCellReuseIdentifier: "ArcanaBaseInfoCell")
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
    
    init(arcana: Arcana, arcanaSection: ArcanaSection) {
        self.arcana = arcana
        self.arcanaSection = arcanaSection
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
        setupViews()
        setupGestures()
        updateHistory()
        checkFavorites()
    }
    
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
        Analytics.setScreenName("ArcanaView", screenClass: nil)
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
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        coordinator.animate(alongsideTransition: { _ in
//            self.tableView.reloadData()
//
//        }) { (_) in
//        }
//    }
    
    func setupViews() {
        
//        isHeroEnabled = true
//        view.heroID = "arcanaCellImage"
        title = arcana.getNameKR()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.addGestureRecognizer(tapShowBarGesture)
        
        updateCompactViews()
        
    }
    
    func updateCompactViews() {
        
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
        
    }
    
    func setupGestures() {
//        panDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
//        panDismissGesture.delegate = self
//        tableView.addGestureRecognizer(panDismissGesture)
        
//        popGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePop(gestureRecognizer:)))
//        popGesture.delegate = self
//        tableView.addGestureRecognizer(popGesture)
    }
    /*
    @objc
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        // calculate the progress based on how far the user moved
        let translation = panDismissGesture.translation(in: nil)
        
        if translation.x > translation.y {
            let progress = translation.x / view.bounds.width
            
            switch panDismissGesture.state {
            case .began:
                // begin the transition as normal
                //            dismiss(animated: true, completion: nil)
                hero_dismissViewController()
            case .changed:
                Hero.shared.update(progress: Double(progress))
                
                // update views' position (limited to only vertical scroll)
                Hero.shared.apply(modifiers: [.position(CGPoint(x: translation.x + view.center.x, y: view.center.y))], to: view)
                
            default:
                // end or cancel the transition based on the progress and user's touch velocity
                if progress + panDismissGesture.velocity(in: nil).x / view.bounds.width > 0.3 {
                    Hero.shared.end()
                } else {
                    Hero.shared.cancel()
                }
            }
            
        }
        else {
            let progress = translation.y / view.bounds.height
            
            switch panDismissGesture.state {
            case .began:
                // begin the transition as normal
                //            dismiss(animated: true, completion: nil)
                hero_dismissViewController()
            case .changed:
                Hero.shared.update(progress: Double(progress))
                
                // update views' position (limited to only vertical scroll)
                Hero.shared.apply(modifiers: [.position(CGPoint(x: view.center.x, y:translation.y + view.center.y))], to: view)
                
            default:
                // end or cancel the transition based on the progress and user's touch velocity
                if progress + panDismissGesture.velocity(in: nil).y / view.bounds.height > 0.3 {
                    Hero.shared.end()
                } else {
                    Hero.shared.cancel()
                }
            }
            
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            if panGesture == panDismissGesture {
                if tableView.contentOffset.y > 0 {
                    if abs(panGesture.velocity(in: nil).y) > abs(panGesture.velocity(in: nil).x) {
                        return false
                    }
                    else {
//                        navigationController?.heroNavigationAnimationType = .pull(direction: .right)
                        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .pull(direction: .right))
                    }
//                    else {
//                        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .pull(direction: .left))
//                    }
                }
                else {
                    if panGesture.velocity(in: nil).y < 0 {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    */
    func animateUpload() {
        
        view.addSubview(animatedView)
        animatedView.anchorCenterYToSuperview()
        animatedView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 100)
        animatedView.addSubview(activityIndicator)
        
        activityIndicator.anchorCenterSuperview()
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.layoutIfNeeded()
        view.bringSubview(toFront: animatedView)
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.animatedView.fadeIn()
        }
        
    }
    
    func animateLabel(success: Bool) {
        
        activityIndicator.removeFromSuperview()
        
        let label = UILabel()
        label.font = APPLEGOTHIC_17
        label.alpha = 0
        
        if success {
            label.text = "업로드 완료!"
        }
        else {
            label.text = "업로드 실패."
        }
        
        animatedView.addSubview(label)
        label.anchorCenterSuperview()
        
        UIView.animate(withDuration: 0.2, animations: {
            label.fadeIn()
        }) { finished in
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.animatedView.fadeOut()
                }, completion: { finished in
                    label.removeFromSuperview()
                    self.animatedView.removeFromSuperview()
                })
            }
        }
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if traitCollection.horizontalSizeClass == .compact {
//            print("COMPACT")
//        }
//        tableView.reloadData()
//    }
//
    
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
                if let image = self.screenShot() {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
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
    
    func screenShot() -> UIImage? {
        
        let savedContentOffset = tableView.contentOffset
        tableView.scrollToRow(at: IndexPath(row: 0, section: tableView.numberOfSections-1), at: .bottom, animated: false)
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0)

//        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        tableView.layer.render(in: context)
        
        for i in 0 ..< tableView.numberOfSections  {
            if tableView.numberOfRows(inSection: i) > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: i), at: .bottom, animated: false)
                guard let context = UIGraphicsGetCurrentContext() else { return nil }
                tableView.layer.render(in: context)
            }
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            tableView.contentOffset = savedContentOffset
            return image
        }
        
        return nil
        
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
        
//        navigationController?.isHeroEnabled = false
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
            
            arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, completion: { arcanaImage in
                
                DispatchQueue.main.async {
                    self.arcanaImageView.animateImage(arcanaImage)
                }
            })
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
                    self.arcanaImageView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.imageScrollView.removeFromSuperview()
            }
            
        }
        
        else {
            UIView.animate(withDuration: 0.2, animations: {
                gestureView.alpha = 0
                self.arcanaImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
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

