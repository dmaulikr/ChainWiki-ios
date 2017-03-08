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

class ArcanaDetail: UIViewController {
    
    let arcana: Arcana
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero
        
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

        let dataRequest = FirebaseService.dataRequest
        dataRequest.incrementCount(ref: FIREBASE_REF.child("arcana/\(arcana.getUID())/numberOfViews"))
        
    }
    
    func setupViews() {

        title = "\(arcana.getNameKR())"
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func exportArcana(_ sender: AnyObject) {
        
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

    @IBAction func edit(_ sender: AnyObject) {
        
        if defaults.canEdit() {
            self.performSegue(withIdentifier: "editArcana", sender: self)
            
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
    
    func toggleHeart(_ sender: UIButton) {
        
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
        }
        else {
            FirebaseService.dataRequest.incrementLikes(uid: arcana.getUID(), increment: false)
        }

        
        defaults.setLikes(value: userInfo)
        
       
    }
    
    func toggleFavorite(_ sender: UIButton) {
        
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
 
    func imageTapped(_ sender: AnyObject) {
        if imageTapped == false {
            // enlarge image
            if let imageView = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/main.jpg") {
                let newImageView = UIImageView(image: imageView)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                view.window!.addSubview(newImageView)
                
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
        UIGraphicsEndImageContext();
        
        return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "editArcana") {
            
            let vc = segue.destination as! ArcanaDetailEdit
            vc.arcana = arcana
            
            
        }
        else {  // EDIT HISTORY
            
            let vc = segue.destination as! ArcanaEditList
            vc.arcanaUID = arcana.getUID()
        }
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
        case .Image: // arcanaImage, buttons
            return 2
        case .Attribute: // arcanaAttribute
            return 6
        case .Skill: // arcanaSkill
            
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
            
        case .Ability:    // Arcana abilities. TODO: Check for 0, 1, 2 abilities.
            
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
            
        case .Kizuna:    // Kizuna
            return 2
            
        case .ChainStory:    // chainstory, chainstone
            var count = 0
            if let _ = arcana.getChainStory() {
                count += 1
            }
            if let _ = arcana.getChainStone() {
                count += 1
            }
            
            return count
            
        case .Tavern: // tavern, (date added)
            if arcana.getTavern() == "" {
                return 0
            }
            else {
                return 1
            }
            
            
        case .Edit:    // edit history
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: section) == 0 {
            return nil
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 1
        }
        else {
            return 20
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
            
        case .Image: // arcanaImage, buttons
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaImage") as! ArcanaImageCell
                cell.layoutMargins = UIEdgeInsets.zero
                cell.arcanaImage.addGestureRecognizer(tap)
                
                
                cell.imageSpinner.startAnimating()
                
                let size = CGSize(width: SCREENWIDTH, height: 400)
                
                if let i = IMAGECACHE.image(withIdentifier: "\(arcana.getUID())/main.jpg") {
                    
                    let aspectScaledToFitImage = i.af_imageAspectScaled(toFit: size)
                    
                    cell.arcanaImage.image = aspectScaledToFitImage
                    cell.imageSpinner.stopAnimating()
                }
                    
                    //  Not in cache, download from firebase
                else {
                    FirebaseService.dataRequest.downloadImage(uid: arcana.getUID(), sender: cell)
                    
                }
                return cell
            }
                
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaButtons") as! ArcanaButtonsCell
                
                cell.numberOfLikes.text = "\(arcana.getNumberOfLikes())"
                
                cell.heart.tag = 0
                cell.heart.addTarget(self, action: #selector(ArcanaDetail.toggleHeart), for: .touchUpInside)
                cell.favorite.tag = 1
                cell.favorite.addTarget(self, action: #selector(ArcanaDetail.toggleFavorite), for: .touchUpInside)
                
                cell.heart.setImage(_: UIImage(named: "heartNormal"), for: .normal)
                cell.heart.setImage(_: UIImage(named: "heartSelected"), for: .selected)
                cell.favorite.setImage(_: UIImage(named: "starNormal"), for: .normal)
                cell.favorite.setImage(_: UIImage(named: "starSelected"), for: .selected)
                
                
                let userLikes = defaults.getLikes()
                if !userLikes.contains(arcana.getUID()) {
                    cell.heart.isSelected = false
                }
                else {
                    cell.heart.isSelected = true
                }
                
                let userFavorites = defaults.getFavorites()
                if !userFavorites.contains(arcana.getUID()) {
                    cell.favorite.isSelected = false
                }
                else {
                    cell.favorite.isSelected = true
                }
                
                return cell
            }
            
            
            
        case .Attribute:    // arcanaAttribute
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsets.zero
            
            var attributeKey = ""
            var attributeValue = ""
            
            switch (indexPath as NSIndexPath).row {
                
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
            
            cell.attributeKey.text = attributeKey
            cell.attributeValue.text = attributeValue
            cell.attributeValue.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case .Skill: // Arcana Skill
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            
            
            // Odd rows will be the description
            //let headerCell = tableView.dequeueReusableCellWithIdentifier("arcanaSkill") as! ArcanaSkillCell
            //let descCell = tableView.dequeueReusableCellWithIdentifier("skillAbilityDesc") as! ArcanaSkillAbilityDescCell
            
            switch (indexPath as NSIndexPath).row {
                
            case 0,2,4:
                let headerCell = tableView.dequeueReusableCell(withIdentifier: "arcanaSkill") as! ArcanaSkillCell
                
                switch (indexPath as NSIndexPath).row {
                    
                case 0:
                    headerCell.skillNumber.text = "스킬 1"
                    headerCell.skillName.text = arcana.getSkillName1()
                    headerCell.skillMana.text = arcana.getSkillMana1()
                    
                case 2:
                    headerCell.skillNumber.text = "스킬 2"
                    headerCell.skillName.text = arcana.getSkillName2()
                    headerCell.skillMana.text = arcana.getSkillMana2()
                default:
                    headerCell.skillNumber.text = "스킬 3"
                    headerCell.skillName.text = arcana.getSkillName3()
                    headerCell.skillMana.text = arcana.getSkillMana3()
                    
                }
                
                headerCell.skillManaCost.text = "마나"
                
                headerCell.layoutMargins = UIEdgeInsets.zero
                return headerCell
                
                
            case 1,3,5:
                let descCell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                
                
                switch (indexPath as NSIndexPath).row {
                case 1:
                    descCell.skillAbilityDesc.text = arcana.getSkillDesc1()
                case 3:
                    descCell.skillAbilityDesc.text = arcana.getSkillDesc2()
                default:
                    descCell.skillAbilityDesc.text = arcana.getSkillDesc3()
                    
                }
                descCell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                descCell.layoutMargins = UIEdgeInsets.zero
                return descCell
                
            default:
                return tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                
            }
            
        // Arcana Ability
        case .Ability:
            
            switch (indexPath as NSIndexPath).row {
            case 0,2,4:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
                
                switch indexPath.row {
                case 0:
                    cell.attributeKey.text = "어빌 1"
                    if arcana.getAbilityName1() == "" {
                        cell.attributeValue.text = " "
                    }
                    else {
                        cell.attributeValue.text = arcana.getAbilityName1()
                    }
                case 2:
                    cell.attributeKey.text = "어빌 2"
                    if arcana.getAbilityName2() == "" {
                        cell.attributeValue.text = " "
                    }
                    else {
                        cell.attributeValue.text = arcana.getAbilityName2()
                    }
                default:
                    cell.attributeKey.text = "파티 어빌"
                    cell.attributeValue.text = " "
                }

                cell.layoutMargins = UIEdgeInsets.zero
                return cell
                
                
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                
                switch indexPath.row {
                case 1:
                    cell.skillAbilityDesc.text = arcana.getAbilityDesc1()
                case 3:
                    cell.skillAbilityDesc.text = arcana.getAbilityDesc2()
                default:
                    cell.skillAbilityDesc.text = arcana.getPartyAbility()
                    
                }

                cell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
        case .Kizuna:
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaSkill") as! ArcanaSkillCell
                cell.skillNumber.text = "인연"
                cell.skillManaCost.text = "코스트"
                cell.skillName.text = arcana.getKizunaName()
                cell.skillMana.text = arcana.getKizunaCost()
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                cell.skillAbilityDesc.text = arcana.getKizunaDesc()
                cell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
            
        case .ChainStory:
            
            switch indexPath.row {
            case 0:
                if let cStory = arcana.getChainStory() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "chainStory") as! ArcanaChainStory
                    cell.storyKey.text = "체인스토리"
                    cell.storyAttribute.text = cStory
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else if let cStone = arcana.getChainStone() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "chainStory") as! ArcanaChainStory
                    cell.storyKey.text = "정령석 보상"
                    cell.storyAttribute.text = cStone
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                }
                else {
                    return UITableViewCell()
                }
                
            default:
                if let cStone = arcana.getChainStone() {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "chainStory") as! ArcanaChainStory
                    cell.storyKey.text = "정령석 보상"
                    cell.storyAttribute.text = cStone
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                }
                    
                else {
                    return UITableViewCell()
                }
            }
            
            
        case .Tavern:
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.attributeKey.text = "출현 장소"
            cell.attributeValue.text = arcana.getTavern()
            return cell
            
        case .Edit:
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewEditsCell") as! ArcanaViewEditsCell
            cell.editLabel.text = "편집 기록 보기"
            cell.arrow.image = #imageLiteral(resourceName: "go")
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 7 {
            self.performSegue(withIdentifier: "editHistory", sender: (indexPath as NSIndexPath).row)
        }
    }

}

