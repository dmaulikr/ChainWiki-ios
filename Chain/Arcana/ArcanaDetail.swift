//
//  ArcanaDetail.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AlamofireImage
import NVActivityIndicatorView

enum ArcanaButton {
    case Heart
    case Favorite
}

protocol ArcanaDetailProtocol : class {
    func toggleHeart(_ cell: ArcanaButtonsCell)
    func toggleFavorite(_ cell: ArcanaButtonsCell)
}

class ArcanaDetail: UIViewController {
    
    let arcana: Arcana
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 20
        tableView.estimatedRowHeight = 160
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero
        
        tableView.register(ArcanaImageCell.self, forCellReuseIdentifier: "ArcanaImageCell")
        tableView.register(ArcanaButtonsCell.self, forCellReuseIdentifier: "ArcanaButtonsCell")
        tableView.register(ArcanaAttributeCell.self, forCellReuseIdentifier: "ArcanaAttributeCell")
        tableView.register(ArcanaSkillCell.self, forCellReuseIdentifier: "ArcanaSkillCell")
        tableView.register(ArcanaSkillAbilityDescCell.self, forCellReuseIdentifier: "ArcanaSkillAbilityDescCell")
        tableView.register(ArcanaChainStoryCell.self, forCellReuseIdentifier: "ArcanaChainStoryCell")
        tableView.register(ArcanaViewEditsCell.self, forCellReuseIdentifier: "ArcanaViewEditsCell")
        
        return tableView
    }()
    
    var heart = false
    var favorite = false
    var imageTapped = false
    var tap = UITapGestureRecognizer()
    
    init(arcana: Arcana) {
        self.arcana = arcana
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHistory()
        setupViews()
        setupNavBar()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        checkFavorites()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let selectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedRow, animated: true)
        
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        let dataRequest = FirebaseService.dataRequest
//        dataRequest.incrementCount(ref: FIREBASE_REF.child("arcana/\(arcana.getUID())/numberOfViews"))
        
    }
    
    func setupViews() {

        title = arcana.getNameKR()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    func setupNavBar() {
        
        let shareButton = UIButton(type: .custom)
        
        shareButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        shareButton.addTarget(self, action: #selector(exportArcana(_:)), for: .touchUpInside)
        shareButton.setImage(#imageLiteral(resourceName: "export"), for: .normal)
        
        let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        shareBarButton.customView = shareButton
        
        let editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editButton.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
        editButton.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        editBarButton.customView = editButton
        
        navigationItem.rightBarButtonItems = [editBarButton, shareBarButton]

    }
    
    func exportArcana(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "앨범에 저장", message: "화면을 캡쳐하겠습니까?", preferredStyle: .alert)
        alertController.view.tintColor = Color.salmon
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 10
        
        let save = UIAlertAction(title: "확인", style: .default, handler: { (action:UIAlertAction) in
            if let image = self.generateImage(tblview: self.tableView) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { (action:UIAlertAction) in
        })
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true) {
            alertController.view.tintColor = Color.salmon
        }
        
        
        
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

    func edit(_ sender: AnyObject) {
        
        if defaults.canEdit() {
            let vc = ArcanaDetailEdit(arcana: arcana)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            showAlert(title: "권한 없음", message: "로그인하면 수정할 수 있습니다.")
        }
    }
    
    func checkFavorites() {
        // TODO: when favoriting, automatically like. when cancelling, only cancel one.
        
        guard let uid = defaults.getUID() else {
            return
        }
        let favRef = FIREBASE_REF.child("user/\(uid)/favorites/\(arcana.getUID())")
        let heartRef = FIREBASE_REF.child("user/\(uid)/likes/\(arcana.getUID())")
        favRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
//                    print("favorited already")
                self.favorite = true
            }
            else {
//                    print("not favorited")
            }
        })
        
        heartRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
//                    print("liked already")
                self.heart = true
            }
            else {
//                    print("not liked")
            }
        })
        
        
    }
   
    func getRarityLong(_ string: String) -> String {
        
        switch string {
            
        case "5★", "5":
            return "★★★★★SSR"
        case "4★", "4":
            return "★★★★SR"
        case "3★", "3":
            return "★★★R"
        case "2★", "2":
            return "★★HN"
        case "1★", "1":
            return "★N"
        default:
            return "업데이트 필요"
        }
        
    }
    
    func imageTapped(_ sender: AnyObject) {
        if imageTapped == false {
            // enlarge image
            if let imageView = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/main.jpg") {
                let newImageView = UIImageView(image: imageView)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                view.window?.addSubview(newImageView)
                
                addGestures(newImageView)
                imageTapped = true
            }
        }
        
    }
    //    (target: self, action: #selector(Home.dismissFilter(_:)))
    func addGestures(_ sender: UIImageView) {
        
        let closeImage = UITapGestureRecognizer(target: self, action: #selector(self.dismissImage(_:)))
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(saveImage(_:)))
        sender.addGestureRecognizer(longPress)
    }
    
    func dismissImage(_ gesture: UIGestureRecognizer) {
        
        guard let gestureView = gesture.view else {
            return
        }
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                gestureView.fadeOut(withDuration: 0.2)
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
                    gestureView.removeFromSuperview()
            }
            
        }
        
        else {
            UIView.animate(withDuration: 0.2, animations: {
                gestureView.alpha = 0
            }) { _ in
                gestureView.removeFromSuperview()
            }

        }
        
        imageTapped = false
    }
    
    func saveImage(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = Color.salmon
        
        let save = UIAlertAction(title: "이미지 저장", style: .default, handler: { (action:UIAlertAction) in
            UIImageWriteToSavedPhotosAlbum(sender as! UIImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { (action:UIAlertAction) in
        })
        
        alertController.addAction(save)
        alertController.addAction(cancel)
    
//        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "저장 실패.", message: error.localizedDescription)
        } else {
            showAlert(title: "저장 완료!", message: "아르카나 정보가 사진에 저장되었습니다.")
        }
    }
    
//    func addToolButtons() {
//        let a = UIBarButtonItem(
//        let item1 = UIBarButtonItem(title: "저장", style: UIBarButtonItemStyle., target: self, action: nil)
//        item1.width = SCREENWIDTH/2
//        item1.customView?.backgroundColor = .black
//        item1.setTitlePositionAdjustment(.init(horizontal: -50, vertical: 0), for: .default)
//        let item2 = UIBarButtonItem(title: "편집", style: .plain, target: self, action: nil)
//        item2.width = SCREENWIDTH/2
//        item2.setTitlePositionAdjustment(.init(horizontal: -50, vertical: 0), for: .default)
//        var items = [UIBarButtonItem]()
//        items.append(item1)
//        items.append(item2)
//        toolBar.setItems(items, animated: true)
//    }

    func generateImage(tblview:UITableView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: tableView.contentSize.width, height: tableView.contentSize.height),false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        let previousFrame = tableView.frame
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.contentSize.width, height: tableView.contentSize.height)

        
        tableView.layer.render(in: context!)
        
        tableView.frame = previousFrame
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

}

// MARK - UITableViewDelegate, UITableViewDataSource
extension ArcanaDetail: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        
        case Image
        case Attribute
        case Skill
        case Ability
        case Kizuna
        case ChainStory
        case Tavern
        case Edit
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .Image:
            return 2
        case .Attribute:
            return 6
        case .Skill:
            
            // Returning 2 * skillCount for description.
            
            switch arcana.getSkillCount() {
            case "1":
                return 2
            case "2":
                return 4
            case "3":
                return 6
            default:
                return 2
            }
            
        case .Ability:
            
            if let _ = arcana.getPartyAbility() {
                return 6
            }
            else if let _ = arcana.getAbilityName2() {    // has 2 abilities
                return 4
            }
            else if let _ = arcana.getAbilityName1() {  // has only 1 ability
                return 2
            }
            else {
                return 0
            }
            
        case .Kizuna:
            return 2
            
        case .ChainStory:
            var count = 0
            if let _ = arcana.getChainStory() {
                count += 1
            }
            if let _ = arcana.getChainStone() {
                count += 1
            }
            
            return count
            
        case .Tavern:
            if arcana.getTavern() == "" {
                return 0
            }
            else {
                return 1
            }
            
        case .Edit:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = Section(rawValue: indexPath.section) else { return 0 }

        switch section {
        case .Image:
            if indexPath.row == 0 {
                return 405
            }
            else {
                return 50
            }
            
        default:
            return UITableViewAutomaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = Section(rawValue: indexPath.section) else { return 0 }

        switch section {
            
        case .Image:
            if indexPath.row == 0 {
                return 405
            }
            else {
                return 50
            }
            
            
        case .Attribute:
            if (indexPath as NSIndexPath).row == 0 {
                return 160
            }
            else {
                return 80
            }
        case .Ability:
            return 80
            
        default:
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.numberOfRows(inSection: section) != 0 {
            guard let section = Section(rawValue: section) else { return 0 }

            switch section {
            case .Image:
                return 0
            default:
                return 10
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
            
        case .Image: // arcanaImage, buttons
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaImageCell") as! ArcanaImageCell
                cell.layoutMargins = UIEdgeInsets.zero
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                
                cell.selectionStyle = .none

                cell.arcanaImage.addGestureRecognizer(tap)
                cell.activityIndicator.startAnimating()
                
                let size = CGSize(width: SCREENWIDTH, height: 400)
                
                if let i = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/main.jpg") {
                    
                    let aspectScaledToFitImage = i.af_imageAspectScaled(toFit: size)
                    
                    cell.arcanaImage.image = aspectScaledToFitImage
                    cell.activityIndicator.stopAnimating()
                }
                    
                    //  Not in cache, download from firebase
                else {
                    FirebaseService.dataRequest.downloadImage(uid: arcana.getUID(), sender: cell)
                    
                }
                return cell
            }
                
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaButtonsCell") as! ArcanaButtonsCell
                cell.layoutMargins = UIEdgeInsets.zero
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                
                cell.selectionStyle = .none
                cell.arcanaDetailDelegate = self
                cell.numberOfLikesLabel.text = "\(arcana.getNumberOfLikes())"

                let userLikes = defaults.getLikes()
                if !userLikes.contains(arcana.getUID()) {
                    cell.heartButton.isSelected = false
                }
                else {
                    cell.heartButton.isSelected = true
                }
                
                let userFavorites = defaults.getFavorites()
                if !userFavorites.contains(arcana.getUID()) {
                    cell.favoriteButton.isSelected = false
                }
                else {
                    cell.favoriteButton.isSelected = true
                }
                
                return cell
            }
            
            
            
        case .Attribute:    // arcanaAttribute
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            var attributeKey = ""
            var attributeValue = ""
            
            switch indexPath.row {
                
            case 0:
                attributeKey = "이름"
                if let nnKR = arcana.getNicknameKR(), let nnJP = arcana.getNicknameJP() {
                    attributeValue = "\(nnKR) \(arcana.getNameKR())\n\(nnJP) \(arcana.getNameJP())"
                }
                else {
                    attributeValue = "\(arcana.getNameKR())\n\(arcana.getNameJP())"
                }
                
                
                
            case 1:
                attributeKey = "레어"
                attributeValue = getRarityLong(arcana.getRarity())
            case 2:
                attributeKey = "직업"
                attributeValue = arcana.getGroup()
            case 3:
                attributeKey = "소속"
                if let a = arcana.getAffiliation() {
                    if a == "" {
                        attributeValue = "정보 없음"
                    }
                    else {
                        attributeValue = a
                    }
                }
                else {
                    attributeValue = "정보 없음"
                }
            case 4:
                attributeKey = "코스트"
                attributeValue = arcana.getCost()
            case 5:
                attributeKey = "무기"
                attributeValue = arcana.getWeapon()
                
            default:
                break
                
            }
            
            
            cell.attributeKeyLabel.text = attributeKey
            cell.attributeValueLabel.text = attributeValue
            cell.attributeValueLabel.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case .Skill: // Arcana Skill
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            
            
            // Odd rows will be the description
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            //let descCell = tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell
            
            switch indexPath.row {
                
            case 0,2,4:
                let headerCell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillCell") as! ArcanaSkillCell
                headerCell.selectionStyle = .none
                switch indexPath.row {
                    
                case 0:
                    headerCell.skillNumberLabel.text = "스킬 1"
                    headerCell.skillNameLabel.text = arcana.getSkillName1()
                    headerCell.skillManaLabel.text = "마나"
                    headerCell.skillManaCostLabel.text = arcana.getSkillMana1()
                    
                case 2:
                    headerCell.skillNumberLabel.text = "스킬 2"
                    headerCell.skillNameLabel.text = arcana.getSkillName2()
                    headerCell.skillManaLabel.text = "마나"
                    headerCell.skillManaCostLabel.text = arcana.getSkillMana2()
                    
                default:
                    headerCell.skillNumberLabel.text = "스킬 3"
                    headerCell.skillNameLabel.text = arcana.getSkillName3()
                    headerCell.skillManaLabel.text = "마나"
                    headerCell.skillManaCostLabel.text = arcana.getSkillMana3()
                    
                }
                
                
                headerCell.layoutMargins = UIEdgeInsets.zero
                return headerCell
                
                
            case 1,3,5:
                let descCell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillAbilityDescCell") as! ArcanaSkillAbilityDescCell
                descCell.selectionStyle = .none
                
                switch (indexPath as NSIndexPath).row {
                case 1:
                    descCell.skillAbilityDescLabel.text = arcana.getSkillDesc1()
                case 3:
                    descCell.skillAbilityDescLabel.text = arcana.getSkillDesc2()
                default:
                    descCell.skillAbilityDescLabel.text = arcana.getSkillDesc3()
                    
                }
                descCell.skillAbilityDescLabel.setLineHeight(lineHeight: 1.2)
                descCell.layoutMargins = UIEdgeInsets.zero
                return descCell
                
            default:
                return tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillAbilityDescCell") as! ArcanaSkillAbilityDescCell
                
            }
            
        // Arcana Ability
        case .Ability:
            
            switch indexPath.row {
            case 0,2,4:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
                cell.selectionStyle = .none
                switch indexPath.row {
                case 0:
                    cell.attributeKeyLabel.text = "어빌 1"
                    if arcana.getAbilityName1() == "" {
                        cell.attributeValueLabel.text = " "
                    }
                    else {
                        cell.attributeValueLabel.text = arcana.getAbilityName1()
                    }
                case 2:
                    cell.attributeKeyLabel.text = "어빌 2"
                    if arcana.getAbilityName2() == "" {
                        cell.attributeValueLabel.text = " "
                    }
                    else {
                        cell.attributeValueLabel.text = arcana.getAbilityName2()
                    }
                default:
                    cell.attributeKeyLabel.text = "파티 어빌"
                    cell.attributeValueLabel.text = " "
                }

                cell.layoutMargins = UIEdgeInsets.zero
                return cell
                
                
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillAbilityDescCell") as! ArcanaSkillAbilityDescCell
                cell.selectionStyle = .none
                switch indexPath.row {
                case 1:
                    cell.skillAbilityDescLabel.text = arcana.getAbilityDesc1()
                case 3:
                    cell.skillAbilityDescLabel.text = arcana.getAbilityDesc2()
                default:
                    cell.skillAbilityDescLabel.text = arcana.getPartyAbility()
                    
                }

                cell.skillAbilityDescLabel.setLineHeight(lineHeight: 1.2)
                
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
        case .Kizuna:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillCell") as! ArcanaSkillCell
                cell.selectionStyle = .none
                cell.skillNumberLabel.text = "인연"
                cell.skillManaLabel.text = "코스트"
                cell.skillNameLabel.text = arcana.getKizunaName()
                cell.skillManaCostLabel.text = arcana.getKizunaCost()
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillAbilityDescCell") as! ArcanaSkillAbilityDescCell
                cell.selectionStyle = .none
                cell.skillAbilityDescLabel.text = arcana.getKizunaDesc()
                cell.skillAbilityDescLabel.setLineHeight(lineHeight: 1.2)
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
            
        case .ChainStory:
            
            switch indexPath.row {
            case 0:
                if let cStory = arcana.getChainStory() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaChainStoryCell") as! ArcanaChainStoryCell
                    cell.selectionStyle = .none
                    cell.storyKeyLabel.text = "체인스토리"
                    cell.storyAttributeLabel.text = cStory
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else if let cStone = arcana.getChainStone() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaChainStoryCell") as! ArcanaChainStoryCell
                    cell.selectionStyle = .none
                    cell.storyKeyLabel.text = "정령석 보상"
                    cell.storyAttributeLabel.text = cStone
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                }
                else {
                    return UITableViewCell()
                }
                
            default:
                if let cStone = arcana.getChainStone() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaChainStoryCell") as! ArcanaChainStoryCell
                    cell.selectionStyle = .none
                    cell.storyKeyLabel.text = "정령석 보상"
                    cell.storyAttributeLabel.text = cStone
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                }
                    
                else {
                    return UITableViewCell()
                }
            }
            
            
        case .Tavern:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
            cell.selectionStyle = .none
            cell.layoutMargins = UIEdgeInsets.zero
            cell.attributeKeyLabel.text = "출현 장소"
            cell.attributeValueLabel.text = arcana.getTavern()
            return cell
            
        case .Edit:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaViewEditsCell") as! ArcanaViewEditsCell
            cell.editLabel.text = "편집 기록 보기"
            cell.arrow.image = #imageLiteral(resourceName: "go")
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section), section == .Edit else { return }
        
        let vc = ArcanaEditList(arcanaID: arcana.getUID())
        navigationController?.pushViewController(vc, animated: true)

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
