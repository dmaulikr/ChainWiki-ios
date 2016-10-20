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

class ArcanaDetail: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    var arcana: Arcana?
    var heart = false
    var favorite = false
    var imageTapped = false
    var tap = UITapGestureRecognizer()
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBAction func exportArcana(_ sender: AnyObject) {
        
        
        if let image = generateImage(tblview: tableView) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        
        
    }
    func updateHistory(){
        var recents = [String]()
        
        
        if let arcana = arcana {
//            let nKR = arcana.nameKR
            let uid = arcana.uid
            recents = defaults.getRecent()
            
            if recents.count == 0 {
                print("empty array")
                recents.append(uid)
            }
                
            else {
                var found = false
                for (index, search) in recents.enumerated() {
                    if uid == search {
                        recents.remove(at: index)
                        recents.append(uid)
                        found = true
                        print("FOUND IN DEFAULTS")
                        break
                    }
                }
                
                if found == false {
                    
                    if recents.count >= 5 {
                        print("array count is 5, remove and then insert")
                        recents.remove(at: 0)
                        recents.append(uid)
                    }
                        
                    else {
                        print("array is small, just append")
                        recents.append(uid)
                    }
                }
            }
            defaults.setRecent(value: recents)
            defaults.set(recents, forKey: "recent")
        }
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
        if let arcana = arcana {
            
            guard let uid = defaults.getUID() else {
                return
            }
            let favRef = FIREBASE_REF.child("user/\(uid)/favorites/\(arcana.uid)")
            let heartRef = FIREBASE_REF.child("user/\(uid)/likes/\(arcana.uid)")
            favRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    print("favorited already")
                    self.favorite = true
                }
                else {
                    print("not favorited")
                }
            })
            
            heartRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    print("liked already")
                    self.heart = true
                }
                else {
                    print("not liked")
                }
            })
        }
        
    }
       
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let arcana = arcana else {
            return 0
        }
        
        switch (section) {
        case 0: // arcanaImage, buttons
            return 2
        case 1: // arcanaAttribute
            return 6
        case 2: // arcanaSkill
            
            // Returning 2 * skillCount for description.
        
            switch arcana.skillCount {
            case "1":
                return 2
            case "2":
                return 4
            case "3":
                return 6
            default:
                return 2
            }
        
        case 3:    // Arcana abilities. TODO: Check for 0, 1, 2 abilities.
            
            if let _ = arcana.abilityName2 {    // has 2 abilities
                return 4
            }
            else if let _ = arcana.abilityName1 {  // has only 1 ability
                return 2
            }
            else {
                return 0
            }
            
        case 4:    // Kizuna
            return 2
            
        case 5:    // chainstory, chainstone
            var count = 0
            if let _ = arcana.chainStory {
                count += 1
            }
            if let _ = arcana.chainStone {
                count += 1
            }
            print(count)
            
            return count
        
        case 6: // tavern, (date added)
            if arcana.tavern == "" {
                return 0
            }
            else {
                return 1
            }
            
            
        default:    // edit history
            return 1
        
        }
  
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
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
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 405
            }
            else {
                return 50
            }
            
            
        case 1:
            if (indexPath as NSIndexPath).row == 0 {
                return 160
            }
            else {
                return 80
            }
        case 3:
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
        
        guard let arcana = arcana else {
            return UITableViewCell()
        }
        switch (indexPath as NSIndexPath).section {
            
        case 0: // arcanaImage, buttons
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaImage") as! ArcanaImageCell
                cell.layoutMargins = UIEdgeInsets.zero
                cell.arcanaImage.addGestureRecognizer(tap)

                
                cell.imageSpinner.startAnimating()
                
                let size = CGSize(width: SCREENWIDTH, height: 400)
                
                if let i = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/main.jpg") {
                    
                    let aspectScaledToFitImage = i.af_imageAspectScaled(toFit: size)
                    
                    cell.arcanaImage.image = aspectScaledToFitImage
                    cell.imageSpinner.stopAnimating()
                }
                    
                    //  Not in cache, download from firebase
                else {
                    //                c.imageSpinner.startAnimation()
                    STORAGE_REF.child("image/arcana/\(arcana.uid)/main.jpg").downloadURL { (URL, error) -> Void in
                        if (error != nil) {
                            print("image download error")
                            // Handle any errors
                        } else {
                            // Get the download URL
                            let urlRequest = URLRequest(url: URL!)
                            
                            DOWNLOADER.download(urlRequest) { response in
                                
                                if let image = response.result.value {
                                    // Set the Image
                                    
                                    
                                    if let thumbnail = UIImage(data: UIImageJPEGRepresentation(image, 0)!) {
                                        cell.imageSpinner.stopAnimating()
                                        let aspectScaledToFitImage = thumbnail.af_imageAspectScaled(toFit: size)
                                        
                                        cell.arcanaImage.image = aspectScaledToFitImage
                                        cell.arcanaImage.alpha = 0
                                        cell.arcanaImage.fadeIn(withDuration: 0.2)
                                        
                                        print("DOWNLOADED")
                                        
                                        // Cache the Image
                                        
                                        IMAGECACHE.add(thumbnail, withIdentifier: "\(arcana.uid)/main.jpg")
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
                return cell
            }
            
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaButtons") as! ArcanaButtonsCell
                cell.heart.tag = 0
                cell.heart.addTarget(self, action: #selector(ArcanaDetail.toggle), for: .touchUpInside)
                cell.favorite.tag = 1
                cell.favorite.addTarget(self, action: #selector(ArcanaDetail.toggle), for: .touchUpInside)
                
                cell.heart.setImage(_: UIImage(named: "heartNormal"), for: .normal)
                cell.heart.setImage(_: UIImage(named: "heartSelected"), for: .selected)
                cell.favorite.setImage(_: UIImage(named: "starNormal"), for: .normal)
                cell.favorite.setImage(_: UIImage(named: "starSelected"), for: .selected)
                
                
                let userHearts = defaults.getHearts()
                if !userHearts.contains(arcana.uid) {
                    cell.favorite.isSelected = false
                }
                else {
                    cell.favorite.isSelected = true
                }
                
                let userFavorites = defaults.getFavorites()
                print("CHECKING")
                if !userFavorites.contains(arcana.uid) {
                    print("FALSE")
                    cell.favorite.isSelected = false
                }
                else {
                    print("TRUE")
                    cell.favorite.isSelected = true
                }
                
                return cell
            }
            
            
            
        case 1:    // arcanaAttribute
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsets.zero
            
            var attributeKey = ""
            var attributeValue = ""
            
            switch (indexPath as NSIndexPath).row {
                
            case 0:
                attributeKey = "이름"
                if let nnKR = arcana.nickNameKR, let nnJP = arcana.nickNameJP {
                    attributeValue = "\(nnKR) \(arcana.nameKR)\n\(nnJP) \(arcana.nameJP)"
                }
                else {
                    attributeValue = "\(arcana.nameKR)\n\(arcana.nameJP)"
                }
                
                
                
            case 1:
                attributeKey = "레어"
                attributeValue = getRarityLong(arcana.rarity)
            case 2:
                attributeKey = "직업"
                attributeValue = arcana.group
            case 3:
                attributeKey = "소속"
                if let a = arcana.affiliation {
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
                attributeValue = arcana.cost
            case 5:
                attributeKey = "무기"
                attributeValue = arcana.weapon
                
            default:
                break
                
            }
            
            cell.attributeKey.text = attributeKey
            cell.attributeValue.text = attributeValue
            cell.attributeValue.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case 2: // Arcana Skill
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
                    headerCell.skillName.text = arcana.skillName1
                    headerCell.skillMana.text = arcana.skillMana1
                    
                case 2:
                    headerCell.skillNumber.text = "스킬 2"
                    headerCell.skillName.text = arcana.skillName2
                    headerCell.skillMana.text = arcana.skillMana2
                default:
                    headerCell.skillNumber.text = "스킬 3"
                    headerCell.skillName.text = arcana.skillName3
                    headerCell.skillMana.text = arcana.skillMana3
    
                }
                
                headerCell.skillManaCost.text = "마나"
                
                headerCell.layoutMargins = UIEdgeInsets.zero
                return headerCell

                
            case 1,3,5:
                let descCell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell

    
                switch (indexPath as NSIndexPath).row {
                case 1:
                    descCell.skillAbilityDesc.text = arcana.skillDesc1
                case 3:
                    descCell.skillAbilityDesc.text = arcana.skillDesc2
                default:
                    descCell.skillAbilityDesc.text = arcana.skillDesc3
                    
                }
                descCell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                descCell.layoutMargins = UIEdgeInsets.zero
                return descCell
                
            default:
                return tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                
            }
            
            // Arcana Ability
        case 3:
            
            switch (indexPath as NSIndexPath).row {
            case 0,2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
                
                if (indexPath as NSIndexPath).row == 0 {
                    cell.attributeKey.text = "어빌 1"
                    cell.attributeValue.text = arcana.abilityName1
                    
                }
                else {
                    cell.attributeKey.text = "어빌 2"
                    cell.attributeValue.text = arcana.abilityName2
                }
                
                cell.layoutMargins = UIEdgeInsets.zero
                return cell


            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell

                
                if indexPath.row == 1 {
                    
//                    let paragraphStyle = NSMutableParagraphStyle()
//                    //line height size
//                    paragraphStyle.lineSpacing = 10
//                    let attrString = NSMutableAttributedString(string: arcana.abilityDesc1)
//                    attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//                    cell.skillAbilityDesc.attributedText = attrString
                    cell.skillAbilityDesc.text = arcana.abilityDesc1
                    

                }
                else {
                    cell.skillAbilityDesc.text = arcana.abilityDesc2
                }
                
                cell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
        case 4:
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaSkill") as! ArcanaSkillCell
                cell.skillNumber.text = "인연"
                cell.skillManaCost.text = "코스트"
                cell.skillName.text = arcana.kizunaName
                cell.skillMana.text = arcana.kizunaCost
                cell.layoutMargins = UIEdgeInsets.zero
                return cell

            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "skillAbilityDesc") as! ArcanaSkillAbilityDescCell
                cell.skillAbilityDesc.text = arcana.kizunaDesc
                cell.skillAbilityDesc.setLineHeight(lineHeight: 1.2)
                cell.layoutMargins = UIEdgeInsets.zero
                return cell
            }
            
        case 5:
            
            switch indexPath.row {
            case 0:
                if let cStory = arcana.chainStory {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "chainStory") as! ArcanaChainStory
                    cell.storyKey.text = "체인스토리"
                    cell.storyAttribute.text = cStory
                    cell.layoutMargins = UIEdgeInsets.zero
                    return cell
                } else if let cStone = arcana.chainStone {
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
                if let cStone = arcana.chainStone {
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
            
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaAttribute") as! ArcanaAttributeCell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.attributeKey.text = "출현 장소"
            cell.attributeValue.text = arcana.tavern
            return cell
            
        default:
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
    
    
    func setupViews() {
        guard let arcana = arcana else {
            return
        }
        self.title = "\(arcana.nameKR)"
//        self.tableView.backgroundColor = UIColor.white
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
    
    func toggle(_ sender: UIButton) {
        
        var type = ""
        var userInfo = [String]()
        if sender.tag == 0 {    // heart
            type = "hearts"
        }
        else {
            type = "favorites"
        }
        if let arcana = arcana, let uid = USERID  {
            
            let ref = FIREBASE_REF.child("user/\(uid)/\(type)/\(arcana.uid)")
            
            
            
            var found = false
            
            for (index, id) in userInfo.enumerated().reversed() {
                if id == arcana.uid {
                    userInfo.remove(at: index)
                    ref.removeValue()
                    found = true
                    break
                }
            }
            
            if found == false {
                // add to array
                userInfo.append(arcana.uid)
                ref.setValue(true)
            }

            
            defaults.setValue(userInfo, forKey: type)
            defaults.synchronize()
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addToolButtons()
        updateHistory()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero;

        scrollViewDidEndDragging(tableView, willDecelerate: true)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        checkFavorites()
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Increment number of views
        let viewRef = FIREBASE_REF.child("arcana/\(arcana!.uid)/numberOfViews")
        viewRef.observeSingleEvent(of: .value, with: { snapshot in
            if let views = snapshot.value as? Int {
                print("numberOfViews is \(views)")
                viewRef.setValue(views+1)
            }
            
        })
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        //navigationController?.hidesBarsOnSwipe = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func imageTapped(_ sender: AnyObject) {
        if imageTapped == false {
            // enlarge image
            if let arcana = arcana {
                if let imageView = IMAGECACHE.image(withIdentifier: "\(arcana.uid)/main.jpg") {
                    let newImageView = UIImageView(image: imageView)
                    newImageView.frame = UIScreen.main.bounds
                    newImageView.backgroundColor = .black
                    newImageView.contentMode = .scaleAspectFit
                    newImageView.isUserInteractionEnabled = true
                    self.view.window!.addSubview(newImageView)
                    
                    addGestures(newImageView)
                    imageTapped = true
                }
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
            // we got back an error!
            let ac = UIAlertController(title: "저장 실패.", message: error.localizedDescription, preferredStyle: .alert)
            ac.view.tintColor = Color.salmon
            ac.view.backgroundColor = .white
            ac.view.layer.cornerRadius = 10
            ac.addAction(UIAlertAction(title: "확인", style: .default))
            
            present(ac, animated: true) {
                ac.view.tintColor = Color.salmon
            }
            
            
        } else {
            let ac = UIAlertController(title: "저장 완료!", message: "아르카나 정보가 사진에 저장되었습니다.", preferredStyle: .alert)
            ac.view.tintColor = Color.salmon
            ac.view.backgroundColor = .white
            ac.view.layer.cornerRadius = 10
            ac.addAction(UIAlertAction(title: "확인", style: .default))
            
            present(ac, animated: true) {
                ac.view.tintColor = Color.salmon
            }
            
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
            vc.arcanaUID = arcana!.uid
        }
    }

}
