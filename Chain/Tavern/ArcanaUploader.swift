//
//  ArcanaUploader.swift
//  Chain
//
//  Created by Jitae Kim on 6/13/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Kanna

class ArcanaUploader: NSObject {
    
    weak var viewControllerDelegate: UploadArcanaViewController?
    static let uploader = ArcanaUploader()
    let converter = ArcanaAttributeConverter.converter
    private var arcanaDict = [String: String]()
    
    func parseArcana(arcanaURL: URL, mainImage: UIImage?, profileImage: UIImage?, completion: @escaping (Error?, Arcana?) -> Void) {
        
        DispatchQueue.main.async {
            self.viewControllerDelegate?.animatingView.setLabel("아르카나 번역 중...")
        }
        
        downloadArcana(arcanaURL: arcanaURL, mainImage: mainImage, profileImage: profileImage) { error in
            
            if let _ = error {
                completion(error, nil)
            }
            else {
                
                DispatchQueue.main.async {
                    self.viewControllerDelegate?.animatingView.setLabel("아르카나 업로드 중...")
                }
                
                self.uploadArcana(completion: { error in
                    
                    if let arcana = Arcana(arcanaDict: self.arcanaDict) {
                        
                        self.uploadImages(arcanaID: arcana.getUID(), mainImage: mainImage, profileImage: profileImage, completion: { error in
                            
                            completion(nil, arcana)
                            
                        })
                    }
                    else {
                        completion(error, nil)
                    }
                    
                })
            }
        }
        
    }
    
    func downloadArcana(arcanaURL: URL, mainImage: UIImage?, profileImage: UIImage?, completion: @escaping (Error?) -> Void) {
        
        arcanaDict.removeAll()
        let group = DispatchGroup()
        
        do {
            let html = try String(contentsOf: arcanaURL, encoding: String.Encoding.utf8)
            
            let translator = GoogleTranslator.translator
            
            var tables = [String : String]()
            var skillCount = "1"
            var foundChainStone = false
            let usefulAttributes = ["名　前", "武器タイプ", "絆ステタイプ", "SKILL", "SKILL 2", "SKILL 3", "ABILITY", "PARTYABILITY", "絆の物語", "入手方法", "運命の物語", "出会いの物語", "絆の物語",  "CHAIN STORY"]
            if html.contains("SKILL 3") {
                skillCount = "3"
            } else if html.contains("SKILL 2") {
                skillCount = "2"
            }
            arcanaDict.updateValue(skillCount, forKey: "skillCount")
                    
            // NEW PAGE-2 stars have an ability, unlike old page.
            // Kanna, search through html
            var oneSkill = true
            if html.contains("SKILL 2") {
                oneSkill = false
            }
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // Now getting tables.
                for table in doc.xpath("//table") {
                    // getting the innerhtml of tables. do i need to do this?
                    // for each table, iterate through the <th>
                    for th in table.xpath(".//th") {
                        //                        print("<<<<<<<\(th.text)")
                        for i in usefulAttributes {
                            let tableKey = th.text!
                            
                            // Some pages have SKILL VOICE.. check that it's not the voice..
                            
                            if tableKey.contains(i) && !tableKey.contains("使用時") {
                                // check for "SKILL" and not 1,2,3
                                if (tableKey.contains("SKILL") || tableKey.contains("SKILL 1")) && !tableKey.contains("SKILL 2") && !tableKey.contains("SKILL 3") {
                                    tables.updateValue(table.innerHTML!, forKey: "SKILL")
                                }
                                else {
                                    if i == ("SKILL")  {
                                    }
                                    else if i == "ABILITY" && tables["ABILITY"] != nil && !tableKey.contains("PARTYABILITY"){
                                        tables.updateValue(table.innerHTML!, forKey: "ABILITY2")
                                        
                                    }
                                    else if i == "ABILITY" && tables["ABILITY"] != nil && tables["ABILITY2"] != nil{
                                        
                                        tables.updateValue(table.innerHTML!, forKey: "PARTYABILITY")
                                    }
                                        // check if 2nd ability
                                        
                                    else {
                                        // print("\(i) IS \(th.innerHTML!)")
                                        tables.updateValue(table.innerHTML!, forKey: i)
                                    }
                                    
                                }
                                
                            }
                        }
                        if th.text!.contains("SKILL") && oneSkill == true && !th.innerHTML!.contains("使用時") {
                            tables.updateValue(table.innerHTML!, forKey: "SKILL")
                            
                        }
                        
                    }
                    
                }
            }
            for (key, value) in tables {
                
                let parse = Kanna.HTML(html: value, encoding: String.Encoding.utf8)
                
                switch key {
                    
                case "名　前":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            arcanaDict.updateValue(attribute, forKey: "nameJP")
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.nameKR.rawValue)
                                }
                            })
                            
                        case 1:
                            
                            arcanaDict.updateValue(converter.getRarity(attribute), forKey: "rarity")
                        case 3:
                            arcanaDict.updateValue(converter.getClass(attribute), forKey: "group")
                        case 4:
                            arcanaDict.updateValue(converter.getAffiliation(attribute), forKey: "affiliation")
                        case 7:
                            arcanaDict.updateValue(attribute, forKey: "cost")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "絆ステタイプ":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        let attribute = link.text!
                        switch index {
                            
                        case 1:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.kizunaName.rawValue)
                                }
                            })
                        case 2:
                            self.arcanaDict.updateValue(attribute, forKey: ArcanaAttribute.kizunaCost.rawValue)
                        case 3:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.kizunaDesc.rawValue)
                                }
                            })
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "武器タイプ":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        if index == 0 {
                            arcanaDict.updateValue(getWeaponJPKR(string: attribute.trimmingCharacters(in: .whitespacesAndNewlines)), forKey: ArcanaAttribute.weapon.rawValue)
                        }
                        else {
                            break
                        }
                        
                        
                    }
                case "SKILL", "SKILL 1":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillName1.rawValue)
                                }
                            })
                        case 1:
                            self.arcanaDict.updateValue(attribute, forKey: ArcanaAttribute.skillMana1.rawValue)
                        case 2:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillDesc1.rawValue)
                                }
                            })
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "SKILL 2":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillName2.rawValue)
                                }
                            })
                        case 1:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillMana2.rawValue)
                                }
                            })
                        case 2:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillDesc2.rawValue)
                                }
                            })
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "SKILL 3":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillName3.rawValue)
                                }
                            })
                        case 1:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillMana3.rawValue)
                                }
                            })
                        case 2:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.skillDesc3.rawValue)
                                }
                            })
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "ABILITY":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        switch index {
                        case 0:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.abilityName1.rawValue)
                                }
                            })
                        case 1:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.abilityDesc1.rawValue)
                                }
                            })
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "ABILITY2":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.abilityName2.rawValue)
                                }
                            })
                        case 1:
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.abilityDesc2.rawValue)
                                }
                            })
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "PARTYABILITY":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        if index == 1 {
                            let attribute = link.text!
                            if attribute != "" {
                                translator.translate(attribute, group: group, completion: { translation in
                                    if let text = translation {
                                        self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.partyAbility.rawValue)
                                    }
                                })
                            }
                            
                            break
                        }
                        
                        
                    }
                    
                case "入手方法":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        switch index {
                        case 0:
                            arcanaDict.updateValue(converter.getTavern(attribute), forKey: "tavern")
                        case 1:
                            arcanaDict.updateValue(attribute, forKey: "dateAdded")
                        default:
                            break
                            
                        }
                        
                    }
                    
                    
                case "運命の物語", "出会いの物語", "絆の物語":
                    
                    if foundChainStone == true {
                        break
                    }
                    for link in parse!.xpath("//td") {
                        
                        let attribute = link.text!
                        if attribute.contains("精霊石") {
                            foundChainStone = true
                            let trailingString = attribute.substring(from: attribute.indexOf("Lv:")!)
                            // possibly more than one chainStone quest
                            let chainStoneLevel = String(NSString(string: trailingString.substring(with: Range<String.Index>(trailingString.index(trailingString.indexOf("Lv:")!, offsetBy: 3)..<trailingString.index(trailingString.indexOf("/")!, offsetBy: 0)))))
                            if let cS = arcanaDict["chainStone"] {
                                if chainStoneLevel == "?" {
                                    arcanaDict.updateValue("\(cS), 레벨 1", forKey: "chainStone")
                                }
                                else {
                                    arcanaDict.updateValue("\(cS), 레벨 \(chainStoneLevel)", forKey: "chainStone")
                                }
                            }
                            else {
                                arcanaDict.updateValue("레벨 \(chainStoneLevel)", forKey: "chainStone")
                            }
                            
                        }
                    }
                    
                case "CHAIN STORY":
                    for link in parse!.xpath("//td") {
                        let attribute = link.text!
                        if attribute.contains("章") && attribute.contains("】") {
                            translator.translate(attribute, group: group, completion: { translation in
                                if let text = translation {
                                    self.arcanaDict.updateValue(text, forKey: ArcanaAttribute.chainStory.rawValue)
                                }
                            })
                            break
                        }
                        
                    }
                    
                    
                default:
                    break
                }
                
            }
        }
        
        catch {
            print(error)
        }
                    
        // WAIT FOR ALL TRANSLATIONS, THEN UPLOAD
        group.notify(queue: DispatchQueue.main, execute: {
            completion(nil)
        })
        
    }
    
    
    func uploadImages(arcanaID: String, mainImage: UIImage?, profileImage: UIImage?, completion: @escaping (Error?) -> Void) {
        
        let imageCacheGroup = DispatchGroup()
        imageCacheGroup.enter()
        imageCacheGroup.enter()
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let mainImage = mainImage {
                imageCache.setObject(mainImage, forKey: "\(arcanaID)/main.jpg" as NSString)
                imageCacheGroup.leave()
            }
            else {
                imageCacheGroup.leave()
            }
            
            if let profileImage = profileImage {
                imageCache.setObject(profileImage, forKey: "\(arcanaID)/icon.jpg" as NSString)
                imageCacheGroup.leave()
            }
            else {
                imageCacheGroup.leave()
            }
        }
        
        imageCacheGroup.notify(queue: DispatchQueue.main, execute: {
            print("images cached")
            print("Uploading Images...")
            
            let imageUploadGroup = DispatchGroup()
            
            imageUploadGroup.enter()
            imageUploadGroup.enter()
            
            if let mainImage = mainImage {
                
                if let data:Data = UIImageJPEGRepresentation(mainImage, 1) {
                    let arcanaImageRef = STORAGE_REF.child("image/arcana/\(arcanaID)/main.jpg")
                    arcanaImageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                        if (error != nil) {
                            print("Main image upload error")
                        } else {
                            print("Uploaded main image for \(arcanaID)")
                        }
                        imageUploadGroup.leave()
                    })
                }
            }
            else {
                imageUploadGroup.leave()
            }
            
            if let profileImage = profileImage {
                
                if let data:Data = UIImageJPEGRepresentation(profileImage, 1) {
                    let arcanaImageRef = STORAGE_REF.child("image/arcana/\(arcanaID)/icon.jpg")
                    arcanaImageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                        if (error != nil) {
                            print("Profile image upload error")
                        } else {
                            print("Uploaded profile image for \(arcanaID)")
                        }
                        imageUploadGroup.leave()
                    })
                }
            }
            else {
                imageUploadGroup.leave()
            }
            
            imageUploadGroup.notify(queue: DispatchQueue.main, execute: {
                print("images uploaded")
                completion(nil)
            })
            
        })
        
        
    }
    
    
    func uploadArcana(completion: @escaping (Error?) -> Void) {
        
        print("STARTING UPLOAD PROCESS")
        
        let uploadGroup = DispatchGroup()
        let arcanaID = ARCANA_REF.childByAutoId().key
        // translate, put korean in dict values.
        arcanaDict["uid"] = arcanaID
        
        // Base Case: only 1 skill, 1 ability. Does not have nickname.
        if arcanaDict[ArcanaAttribute.affiliation.rawValue] == nil {
            arcanaDict[ArcanaAttribute.affiliation.rawValue] = ""
        }
        
        // TODO: Change base case to 1 skill 0 ability...
        guard let nKR = arcanaDict["nameKR"], let nJP = arcanaDict["nameJP"], let r = arcanaDict["rarity"], let g = arcanaDict["group"], let t = arcanaDict["tavern"], let a = arcanaDict["affiliation"], let c = arcanaDict["cost"], let w = arcanaDict["weapon"], let kN = arcanaDict["kizunaName"], var kC = arcanaDict["kizunaCost"], let kD = arcanaDict["kizunaDesc"], let sC = arcanaDict["skillCount"], let sN1 = arcanaDict["skillName1"], let sM1 = arcanaDict["skillMana1"], let sD1 = arcanaDict["skillDesc1"] else {
            
            print("ARCANA DICIONARY VALUE IS NIL")
            return
        }
            
        if kC == "" {
            kC = kC.fixEmptyString(rarity: r)
        }
        
        let tavern = converter.getTavernRef(tavern: t)
        if tavern != "" {
            FIREBASE_REF.child("tavern").child(tavern).child(arcanaID).setValue(true, withCompletionBlock: { (error, reference) in
                print("DONE")
            })
        }
        
        let arcanaOneSkill = ["uid" : arcanaID, "nameKR" : "\(nKR)", "nameJP" : "\(nJP)", "rarity" : "\(r)", "class" : "\(g)", "tavern" : "\(t)", "affiliation" : "\(a)", "cost" : "\(c)", "weapon" : "\(w)", "kizunaName" : "\(kN)", "kizunaCost" : "\(kC)", "kizunaDesc" : "\(kD)", "skillCount" : "\(sC)", "skillName1" : "\(sN1)", "skillMana1" : "\(sM1)", "skillDesc1" : "\(sD1)", "numberOfViews" : 0] as [String : Any]
            
        let arcanaRef = [arcanaID : arcanaOneSkill]
            
        // check for ability types
        findAbilities()
        uploadGroup.enter()
        
        ARCANA_REF.updateChildValues(arcanaRef, withCompletionBlock: { (error, reference) in
            
            //            downloadImages(nameJP: self.nameField.text!, imageURL: self.imageField.text!, iconURL: self.iconField.text!)
            // check for chainStory, chainStone, dateAdded
            let arcanaRef = ARCANA_REF.child(arcanaID)
            
            uploadGroup.enter()
            arcanaRef.updateChildValues(["numberOfLikes" : 0], withCompletionBlock: { (error, reference) in
                uploadGroup.leave()
            })
            
            if let d = self.arcanaDict["dateAdded"] {
                
                uploadGroup.enter()
                arcanaRef.updateChildValues(["dateAdded" : "\(d)"], withCompletionBlock: { (error, reference) in
                    uploadGroup.leave()
                })
                
            }
            
            if let cStory = self.arcanaDict["chainStory"] {
                
                uploadGroup.enter()
                arcanaRef.updateChildValues(["chainStory" : "\(cStory)"], withCompletionBlock: { (error, reference) in
                    uploadGroup.leave()
                })
                
            }
            
            if let d = self.arcanaDict["dateAdded"] {
                
                uploadGroup.enter()
                arcanaRef.updateChildValues(["dateAdded" : "\(d)"], withCompletionBlock: { (error, reference) in
                    uploadGroup.leave()
                })
                
            }
            
            if let cStone = self.arcanaDict["chainStone"] {
                
                uploadGroup.enter()
                arcanaRef.updateChildValues(["chainStone" : "\(cStone)"], withCompletionBlock: { (error, reference) in
                    uploadGroup.leave()
                })
                
            }
            
            if !r.contains("1") {
                if let aN1 = self.arcanaDict["abilityName1"], let aD1 = self.arcanaDict["abilityDesc1"] {
                    
                    let ability1 = ["abilityName1" : "\(aN1)", "abilityDesc1" : "\(aD1)"]
                    uploadGroup.enter()
                    arcanaRef.updateChildValues(ability1, withCompletionBlock: { (error, reference) in
                        uploadGroup.leave()
                    })
                    
                }
            }
            
            // Check if arcana has 2 abilities
            if r.contains("5") || r.contains("4") {
                
                if let aN2 = self.arcanaDict["abilityName2"], let aD2 = self.arcanaDict["abilityDesc2"] {
                    
                    let abilityRef = ["abilityName2" : "\(aN2)", "abilityDesc2" : "\(aD2)"]
                    uploadGroup.enter()
                    arcanaRef.updateChildValues(abilityRef, withCompletionBlock: { (error, reference) in
                        uploadGroup.leave()
                    })
                    
                }
                
                if let pA = self.arcanaDict["partyAbility"] {
                    
                    let pARef = ["partyAbility" : "\(pA)"]
                    uploadGroup.enter()
                    arcanaRef.updateChildValues(pARef, withCompletionBlock: { (error, reference) in
                        uploadGroup.leave()
                    })
                }
                
                // Check if arcana has at least 2 skills
                if let sN2 = self.arcanaDict["skillName2"], let sM2 = self.arcanaDict["skillMana2"], let sD2 = self.arcanaDict["skillDesc2"] {
                    
                    uploadGroup.enter()
                    
                    switch (sC) {
                        
                    case "2":
                        
                        let skill2 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)"]
                        arcanaRef.updateChildValues(skill2, withCompletionBlock: { (error, reference) in
                            uploadGroup.leave()
                        })
                        
                    case "3":
                        
                        if let sN2 = self.arcanaDict["skillName2"], let sM2 = self.arcanaDict["skillMana2"], let sD2 = self.arcanaDict["skillDesc2"], let sN3 = self.arcanaDict["skillName3"], let sM3 = self.arcanaDict["skillMana3"], let sD3 = self.arcanaDict["skillDesc3"] {
                            let skill3 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)", "skillName3" : "\(sN3)", "skillMana3" : "\(sM3)", "skillDesc3" : "\(sD3)"]
                            arcanaRef.updateChildValues(skill3, withCompletionBlock: { (error, reference) in
                                uploadGroup.leave()
                                
                            })
                        }
                        
                    default:
                        
                        uploadGroup.leave()
                        break
                        
                    }
                    
                }
                
            }
            
            uploadGroup.leave()
        })
        
        // WAIT FOR ALL UPLOADS
        uploadGroup.notify(queue: DispatchQueue.main, execute: {
            
            completion(nil)
        })
        
    }
    
    func findAbilities() {
        
        let abilityRef = FIREBASE_REF.child("ability")
        
        if let id = arcanaDict["uid"] {
            if let sD1 = arcanaDict["skillDesc1"] {
                if sD1.contains("아군") && sD1.contains("공격력") {
                    let buffRef = abilityRef.child("buff").child(id)
                    buffRef.setValue(true)
                }
            }
            if let sD2 = arcanaDict["skillDesc2"] {
                if sD2.contains("아군") && sD2.contains("공격력") {
                    let buffRef = abilityRef.child("buff").child(id)
                    buffRef.setValue(true)
                }
            }
            if let sD3 = arcanaDict["skillDesc3"] {
                if sD3.contains("아군") && sD3.contains("공격력") {
                    let buffRef = abilityRef.child("buff").child(id)
                    buffRef.setValue(true)
                }
            }
            
            if let aD1 = arcanaDict["abilityDesc1"] {
                if aD1.contains("서브") && !aD1.contains("마나를") {
                    let abilityRef = abilityRef.child("subAbility").child(id)
                    abilityRef.setValue(true)
                } else if aD1.contains("마나를") && aD1.contains("시작") {
                    let abilityRef = abilityRef.child("manaAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("마나 슬롯") && aD1.contains("속도") && !aD1.contains("이동 속도") {
                    let abilityRef = abilityRef.child("manaSlotAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("마나 슬롯 때") || (aD1.contains("마나") && aD1.contains("쉽게한다")) {
                    let abilityRef = abilityRef.child("manaChanceAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("보물") {
                    let abilityRef = abilityRef.child("treasureAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("골드") {
                    let abilityRef = abilityRef.child("goldAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("경험치") {
                    let abilityRef = abilityRef.child("expAbility").child(id)
                    abilityRef.setValue(true)
                }
                
                if aD1.contains("필살기") {
                    let abilityRef = abilityRef.child("skillUpAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("AP") {
                    let abilityRef = abilityRef.child("apRecoverAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("보스") {
                    let abilityRef = abilityRef.child("bossWaveAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD1.contains("웨이브가 시작 할 때마다") || aD1.contains("웨이브가 진행될때마다") {
                    if (aD1.contains("회복한다") || aD1.contains("회복하고")) && (aD1.contains("낮은 동료") || aD1.contains("가까이") || aD1.contains("아군 전체")) {
                        let abilityRef = abilityRef.child("partyHealAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    
                }
                if aD1.contains("적에게") {
                    if aD1.contains("독") {
                        let abilityRef = abilityRef.child("poisonAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("암흑") || aD1.contains("어둠") {
                        let abilityRef = abilityRef.child("darkAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("스러운") || aD1.contains("슬로우") {
                        let abilityRef = abilityRef.child("slowAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("저주") {
                        let abilityRef = abilityRef.child("curseAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("쇠약") {
                        let abilityRef = abilityRef.child("weakAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("백골") {
                        let abilityRef = abilityRef.child("skeletonAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("다운") {
                        let abilityRef = abilityRef.child("stunAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("동결") {
                        let abilityRef = abilityRef.child("frostAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD1.contains("다운") {
                        let abilityRef = abilityRef.child("downAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    
                }
                if aD1.contains("상태로한다") || aD1.contains("추가된다") || aD1.contains("만든다") {
                    if aD1.contains("독") {
                        abilityRef.child("poisonStrikeAbility").child(id).setValue(true)
                    }
                    if aD1.contains("슬로우") || aD1.contains("스러운") {
                        abilityRef.child("slowStrikeAbility").child(id).setValue(true)
                    }
                    if aD1.contains("암흑") || aD1.contains("어둠") {
                        abilityRef.child("darkStrikeAbility").child(id).setValue(true)
                    }
                    if aD1.contains("동결") {
                        abilityRef.child("frostStrikeAbility").child(id).setValue(true)
                    }
                }
                if aD1.contains("않는다") {
                    if aD1.contains("독") {
                        abilityRef.child("poisonImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("슬로우") || aD1.contains("스러운") {
                        abilityRef.child("slowImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("암흑") || aD1.contains("어둠") {
                        abilityRef.child("darkImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("동결") {
                        abilityRef.child("frostImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("쇠약") {
                        abilityRef.child("weakImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("백골") {
                        abilityRef.child("skeletonImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("다운") {
                        abilityRef.child("stunImmuneAbility").child(id).setValue(true)
                    }
                    if aD1.contains("봉인") {
                        abilityRef.child("sealImmuneAbility").child(id).setValue(true)
                    }
                    
                }
                
            }
            if let aD2 = arcanaDict["abilityDesc2"] {
                if aD2.contains("서브") && !aD2.contains("마나를") {
                    let abilityRef = abilityRef.child("subAbility").child(id)
                    abilityRef.setValue(true)
                } else if aD2.contains("마나를") && aD2.contains("시작"){
                    let abilityRef = abilityRef.child("manaAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("마나 슬롯") && aD2.contains("속도") && !aD2.contains("이동 속도") {
                    let abilityRef = abilityRef.child("manaSlotAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("마나 슬롯 때") || (aD2.contains("마나") && aD2.contains("쉽게한다")) {
                    let abilityRef = abilityRef.child("manaChanceAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("보물") {
                    let abilityRef = abilityRef.child("treasureAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("골드") {
                    let abilityRef = abilityRef.child("goldAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("경험치") {
                    let abilityRef = abilityRef.child("expAbility").child(id)
                    abilityRef.setValue(true)
                }
                
                if aD2.contains("필살기") {
                    let abilityRef = abilityRef.child("skillUpAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("AP") {
                    let abilityRef = abilityRef.child("apRecoverAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("보스") {
                    let abilityRef = abilityRef.child("bossWaveAbility").child(id)
                    abilityRef.setValue(true)
                }
                if aD2.contains("웨이브가 시작 할 때마다") || aD2.contains("웨이브가 진행될때마다") {
                    if (aD2.contains("회복한다") || aD2.contains("회복하고")) && (aD2.contains("낮은 동료") || aD2.contains("가까이") || aD2.contains("아군 전체")) {
                        let abilityRef = abilityRef.child("partyHealAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    
                }
                if aD2.contains("적에게") {
                    if aD2.contains("독") {
                        let abilityRef = abilityRef.child("poisonAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("암흑") || aD2.contains("어둠") {
                        let abilityRef = abilityRef.child("darkAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("스러운") || aD2.contains("슬로우") {
                        let abilityRef = abilityRef.child("slowAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("저주") {
                        let abilityRef = abilityRef.child("curseAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("쇠약") {
                        let abilityRef = abilityRef.child("weakAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("백골") {
                        let abilityRef = abilityRef.child("skeletonAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("다운") {
                        let abilityRef = abilityRef.child("stunAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("동결") {
                        let abilityRef = abilityRef.child("frostAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    if aD2.contains("다운") {
                        let abilityRef = abilityRef.child("downAttackUpAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    
                }
                
                if aD2.contains("않는다") {
                    if aD2.contains("독") {
                        abilityRef.child("poisonImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("슬로우") || aD2.contains("스러운") {
                        abilityRef.child("slowImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("암흑") || aD2.contains("어둠") {
                        abilityRef.child("darkImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("동결") {
                        abilityRef.child("frostImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("쇠약") {
                        abilityRef.child("weakImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("백골") {
                        abilityRef.child("skeletonImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("다운") {
                        abilityRef.child("stunImmuneAbility").child(id).setValue(true)
                    }
                    if aD2.contains("봉인") {
                        abilityRef.child("sealImmuneAbility").child(id).setValue(true)
                    }
                    
                }
                
            }
            if let k = arcanaDict["kizunaDesc"] {
                if k.contains("서브") && !k.contains("마나를") {
                    let kizunaRef = abilityRef.child("subKizuna").child(id)
                    kizunaRef.setValue(true)
                } else if k.contains("마나를") && k.contains("시작") {
                    let kizunaRef = abilityRef.child("manaKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                if k.contains("마나 슬롯") {
                    let kizunaRef = abilityRef.child("manaChanceKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                if k.contains("보물") {
                    let kizunaRef = abilityRef.child("treasureKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                if k.contains("골드") {
                    let kizunaRef = abilityRef.child("goldKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                if k.contains("경험치") {
                    let kizunaRef = abilityRef.child("expKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                if k.contains("필살기") {
                    let kizunaRef = abilityRef.child("skillUpKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                
                if k.contains("보스") {
                    let kizunaRef = abilityRef.child("bossWaveKizuna").child(id)
                    kizunaRef.setValue(true)
                }
                if k.contains("않는다") {
                    if k.contains("독") {
                        abilityRef.child("poisonImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("슬로우") || k.contains("스러운") {
                        abilityRef.child("slowImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("암흑") || k.contains("어둠") {
                        abilityRef.child("darkImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("동결") {
                        abilityRef.child("frostImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("쇠약") {
                        abilityRef.child("weakImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("백골") {
                        abilityRef.child("skeletonImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("다운") {
                        abilityRef.child("stunImmuneAbility").child(id).setValue(true)
                    }
                    if k.contains("봉인") {
                        abilityRef.child("sealImmuneAbility").child(id).setValue(true)
                    }
                    
                }
                
                if k.contains("웨이브가 시작 할 때마다") || k.contains("웨이브가 진행될때마다") {
                    if (k.contains("회복한다") || k.contains("회복하고")) && (k.contains("낮은 동료") || k.contains("가까이") || k.contains("아군 전체")) {
                        let kizunaRef = abilityRef.child("partyHealKizuna").child(id)
                        kizunaRef.setValue(true)
                    }
                    
                }
                if k.contains("적에게") {
                    if k.contains("독") {
                        let abilityRef = abilityRef.child("poisonAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("암흑") || k.contains("어둠") {
                        let abilityRef = abilityRef.child("darkAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("스러운") || k.contains("슬로우") {
                        let abilityRef = abilityRef.child("slowAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("저주") {
                        let abilityRef = abilityRef.child("curseAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("쇠약") {
                        let abilityRef = abilityRef.child("weakAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("백골") {
                        let abilityRef = abilityRef.child("skeletonAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("다운") {
                        let abilityRef = abilityRef.child("stunAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("동결") {
                        let abilityRef = abilityRef.child("frostAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    if k.contains("다운") {
                        let abilityRef = abilityRef.child("downAttackUpKizuna").child(id)
                        abilityRef.setValue(true)
                    }
                    
                }
            }
        }
        
    }

}

extension String {
    
    func indexOf(_ string: String) -> String.Index? {
        return range(of: string, options: .literal, range: nil, locale: nil)?.lowerBound
    }
    
    func deleteHTMLTag(_ tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(_ tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
}
