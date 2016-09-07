//
//  ArcanaDatabase.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Kanna
import SwiftyJSON
import Firebase
import Foundation

class ArcanaDatabase: UIViewController {

    // let google = "https://www.google.com/searchbyimage?&image_url="
    // let imageURL = "https://cdn.img-conv.gamerch.com/img.gamerch.com/xn--eckfza0gxcvmna6c/149117/20141218143001Q53NTilN.jpg"
    let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
    let group = dispatch_group_create()

    let arcanaURL = "幸運に導く戦士ニンファ"
    let dispatch_group = dispatch_group_create()

    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    var attributeValues = [String]()
    var urls = [String]()
    var dict = [String : String]()
    var arcanaID: Int?
    
    func handleImage() {
        let ref = FIREBASE_REF.child("arcana")
        ref.observeEventType(.ChildChanged, withBlock: { snapshot in
            print(snapshot)
        //ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
                let imageURL = snapshot.value!["imageURL"] as! String
                let url = NSURL(string: imageURL)
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("DOWNLOAD IMAGE ERROR")
                    }
                    
                    if let data = data {
                        print("DOWNLOADED IMAGE!")
                        // upload to firebase storage.
                        
                        let arcanaImageRef = STORAGE_REF.child("image/arcana/\(snapshot.value!["uid"] as! String)/main.jpg")
                        
                        arcanaImageRef.putData(NSData(data: data), metadata: nil) { metadata, error in
                            if (error != nil) {
                                print("ERROR OCCURED WHILE UPLOADING IMAGE")
                                // Uh-oh, an error occurred!
                            } else {
                                // Metadata contains file metadata such as size, content-type, and download URL.
                                print("UPLOADED IMAGE.")
                                //let downloadURL = metadata!.downloadURL
                            }
                        }

                    }
                    
                })
                task.resume()
        })
    
    }

    func downloadTavern() {
        
        let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")

        
        do {
            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
            if html.containsString("入　手　方　法") {
                print("FOUND 入　手　方　法")
                let trim = html.substringWithRange(Range<String.Index>(html.indexOf("入　手　方　法")!..<html.indexOf("専　用　武　器")!))
                print(trim)
                if let doc = Kanna.HTML(html: trim, encoding: NSUTF8StringEncoding) {
                    for tavern in doc.xpath(".//a[@href]") {
                        print(tavern.text)
                    }

                }
            }
            

            
        } catch {
            print("PARSING ERROR")
        }

    }
    
    func downloadWeaponAndPicture(string: String) {

        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        
        
        let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")
        
        do {
            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
        
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {

                var textWithWeapon = ""
                // Search for nodes by XPath
                findingTable : for (index, link) in doc.xpath("//table[@id='']").enumerate() {
                    
                    let tables = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                    
                    guard let linkText = link.text else {
                        return
                    }
                    if index == 0 {
                        for a in tables!.xpath("//a | //link") {
                            if let a = a["href"] {
                                dict.updateValue("\(a)", forKey: "imageURL")
                            }
                            else {
                                print("IMAGE URL NOT FOUND")
                            }
                        }
                    }
                    if linkText.containsString("斬") || linkText.containsString("打") || linkText.containsString("突") || linkText.containsString("弓") || linkText.containsString("魔") || linkText.containsString("聖") || linkText.containsString("拳") || linkText.containsString("銃") || linkText.containsString("狙") {
                        
                        
                        // Nested Loop. Should return right at first iteration.
                        for (weaponIndex, a) in tables!.xpath(".//a['title']").enumerate() {
                            
                            if weaponIndex == 0 {
                                if let text = a.text {
                                    textWithWeapon.appendContentsOf(text)
                                    break findingTable
                                }
                            }
                        }
                        
                    }

                }
                
                if textWithWeapon == "" {
                    print("WEAPON IS BLANK")
                }
                dict.updateValue("\(getWeapon(textWithWeapon)) / \(textWithWeapon)", forKey: "weapon")
            }
            
        } catch {
            print("PARSING ERROR")
        }
        
    }

    // MARK: Given old or new page, parses the page.
    func downloadAttributes(string: String, html: String) {
        
        if string == "new" {
                
                print("IDENTIFIED NEW PAGE")
                //downloadWeaponAndPicture("new")
                
                // Kanna, search through html
                
                if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
                    // TODO: check for # of skills
                    var numberOfSkills = 0
                    
                    if !html.containsString("SKILL 2") {    // Only has 1 skill
                        numberOfSkills = 1
                    }
                    else if !html.containsString("SKILL 3") {   // Only has 2 skills
                        numberOfSkills = 2
                    }
                    else {  // Only has 3 skills
                        numberOfSkills = 3
                    }
                    
                    var numberOfAbilities = 0
                    
                    
                    // Fetched required attributes
                    for (index, link) in doc.xpath("//tbody").enumerate() {
                        print("LOOPING THROUGH ATTRIBUTES")
                        switch index {
                            
                        case 0: // Arcana base info
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                switch attIndex {
                                case 0:
                                    // use this name to search through arcanaData.txt and find name+nickname
                                    //self.dict.updateValue(attribute, forKey: "nameJP")
                                    
                                    self.getAttributes(attribute)
                                    //self.downloadIcon(attribute)
                                //self.translate(attribute, key: "nameKR")
                                case 1:
                                    let rarity = self.getRarity(attribute)
                                    // check if rarity is 3 or lower
                                    if rarity != "5★" && rarity != "4★" {
                                        numberOfAbilities = 1
                                    }
                                    
                                    self.dict.updateValue(rarity, forKey: "rarity")
                                case 3:
                                    
                                    // Check if this arcana existed in arcanaData
                                    //if self.dict["group"] == nil {
                                    
                                    self.dict.updateValue(self.getClass(attribute), forKey: "group")
                                //}
                                case 4:
                                    // Check if this arcana existed in arcanaData
                                    //  if self.dict["affiliation"] == nil {
                                    
                                    self.dict.updateValue(self.getAffiliation(attribute), forKey: "affiliation")
                                // }
                                case 7:
                                    self.dict.updateValue(attribute, forKey: "cost")
                                default:
                                    break
                                }
                            }
                            
                            
                        case 2: // Kizuna
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                switch attIndex {
                                    
                                case 1:
                                    
                                    self.translate(attribute, key: "kizunaName")
                                case 2:
                                    self.dict.updateValue(attribute, forKey: "kizunaCost")
                                case 3:
                                    
                                    self.translate(attribute, key: "kizunaAbility")
                                default:
                                    break
                                }
                            }
                            
                        case 3: // Skill 1
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                switch attIndex {
                                    
                                case 0:
                                    
                                    self.translate(attribute, key: "skillName1")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana1")
                                case 2:
                                    
                                    self.translate(attribute, key: "skillDesc1")
                                default:
                                    break
                                }
                            }
                            
                            // Skip cases 4,5 if only one skill
                            
                        case 4: // Skill 2
                            if numberOfSkills == 1 {
                                // Just get ability 1
                                self.dict.updateValue("1", forKey: "skillCount")
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                                
                                break
                            }
                            
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                switch attIndex {
                                    
                                case 0:
                                    
                                    self.translate(attribute, key: "skillName2")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana2")
                                case 2:
                                    
                                    self.translate(attribute, key: "skillDesc2")
                                default:
                                    break
                                }
                            }
                            
                        case 5:
                            
                            switch numberOfSkills {
                                
                            case 1:
                                // TODO: Check if only 1 ability
                                if numberOfAbilities == 1 {
                                    break
                                }
                                // Just get ability 2
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                print("ABILITY 2 TEXT")
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName2")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc2")
                                    default:
                                        break
                                    }
                                }
                                break
                                
                            case 2:
                                // Just get ability 1
                                self.dict.updateValue("2", forKey: "skillCount")
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                                break
                                
                            default:
                                
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    
                                    guard let attribute = a.text else {
                                        print("ATTRIBUTE IS UNWRAPPED")
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "skillName3")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "skillMana3")
                                    case 2:
                                        
                                        self.translate(attribute, key: "skillDesc3")
                                    default:
                                        break
                                    }
                                }
                            }
                            
                        case 6:
                            if numberOfSkills == 1 {
                                break
                            }
                            else if numberOfSkills == 2 { // numberofskills 2, get ability 2
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName2")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc2")
                                    default:
                                        break
                                    }
                                }
                            }
                            else {  // numberofskills = 3
                                self.dict.updateValue("3", forKey: "skillCount")
                                
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                            }
                            
                            break
                            
                        case 7:
                            guard numberOfSkills == 3 else {
                                print("ONLY 1 OR 2 SKILL, DON'T COME THIS FAR")
                                break
                            }
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                switch attIndex {
                                    
                                case 0:
                                    
                                    self.translate(attribute, key: "abilityName2")
                                case 1:
                                    
                                    self.translate(attribute, key: "abilityDesc2")
                                default:
                                    break
                                }
                            }
                            
                        default:
                            break
                        }
                        
                    }
                    // After fetching, print array
                    //                    dispatch_async(dispatch_get_main_queue()) {
                    //                        //self.uploadArcana()
                    //
                    //                    }
                    
                    
                    
                }
            }
        
        
        else {
            print("IDENTIFIED OLD PAGE")
            
            
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
                
                // Search for nodes by XPath
                for (index, link) in doc.xpath("//table[@id='']").enumerate() {
                    
                    let tables = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                    
                    guard let linkText = link.text else {
                        return
                    }
                    if index == 0 {
                        for a in tables!.xpath("//a | //link") {
                            if let a = a["href"] {
                                print(a)
                                self.dict.updateValue("\(a)", forKey: "imageURL")
                            }
                            else {
                                print("IMAGE URL NOT FOUND")
                            }
                        }
                    }
                }
            }
            
            // Already has skill count 1
            self.dict.updateValue("1", forKey: "skillCount")
            guard let h = html.indexOf("ス　キ　ル　範　囲") else {
                print("POSSIBLY BLANK PAGE FOR  \(html)")
                return
            }
            let trim = NSString(string: html.substringWithRange(Range<String.Index>(html.indexOf("<hr />")!..<h)))
            let lines = trim.componentsSeparatedByString("<br>")
            for (index, i) in lines.enumerate() {
                let regexSpan = try! NSRegularExpression(pattern: "<span.*</span></span>", options: [.CaseInsensitive])
                let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.CaseInsensitive])
                let rangeSpan = NSMakeRange(0, i.characters.count)
                
                let spanLessString :String = regexSpan.stringByReplacingMatchesInString(i, options: [], range:rangeSpan, withTemplate: "")
                let range = NSMakeRange(0, spanLessString.characters.count)
                
                let htmlLessString :String = regex.stringByReplacingMatchesInString(spanLessString, options: [], range:range, withTemplate: "")
                
                let attribute = htmlLessString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                //print(index, attribute)
                var numberOfAbilities = 2
                switch index {
                case 0:
                    self.dict.updateValue(attribute, forKey: "nameJP")
                    //self.downloadIcon(attribute)
                    self.translate(attribute, key: "nameKR")
                case 1:
                    let rarity = self.getRarity(attribute)
                    // check if rarity is 3 or lower
                    if rarity != "5★" && rarity != "4★" {
                        numberOfAbilities = 1
                    }
                    self.dict.updateValue(rarity, forKey: "rarity")
                    
                case 4:// Old pages have no affiliation..
                    self.dict.updateValue(self.getAffiliation(attribute), forKey: "affiliation")
                case 5:
                    self.dict.updateValue(attribute, forKey: "cost")
                case 6:
                    // TODO: Get group inside ()
                    let group = NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf("(")!.advancedBy(1)..<attribute.indexOf(")")!)))
                    self.dict.updateValue(self.getClass(group as String), forKey: "group")
                case 7:
                    self.dict.updateValue(self.getWeapon(attribute), forKey: "weapon")
                case 16:
                    let skillName1 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.startIndex..<attribute.indexOf(" (")!))))
                    self.translate(skillName1, key: "skillName1")
                    let skillMana1 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf(")*")!.advancedBy(2)..<attribute.indexOf(")*")!.advancedBy(3)))))
                    self.translate(skillMana1, key: "skillMana1")
                    let skillDesc1 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf(")*")!.advancedBy(3)..<attribute.endIndex))))
                    self.translate(skillDesc1, key: "skillDesc1")
                    
                case 17:
                    let abilityName1 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.startIndex..<attribute.indexOf("　")!.predecessor()))))
                    self.translate(abilityName1, key: "abilityName1")
                    let abilityDesc1 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf("　")!.advancedBy(1)..<attribute.endIndex))))
                    self.translate(abilityDesc1, key: "abilityDesc1")
                    
                case 18:
                    if numberOfAbilities == 1 {
                        break
                    }
                    else {
                        let abilityName2 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.startIndex..<attribute.indexOf("　")!.predecessor()))))
                        self.translate(abilityName2, key: "abilityName2")
                        let abilityDesc2 = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf("　")!.advancedBy(1)..<attribute.endIndex))))
                        self.translate(abilityDesc2, key: "abilityDesc2")
                    }
                    
                case 19:
                    let kizunaName = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                    self.translate(kizunaName, key: "kizunaName")
                    let kizunaCost = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf("+")!.advancedBy(1)..<attribute.indexOf("+")!.advancedBy(2)))))
                    self.translate(kizunaCost, key: "kizunaCost")
                    let kizunaAbility = String(NSString(string: attribute.substringWithRange(Range<String.Index>(attribute.indexOf(")　")!.advancedBy(2)..<attribute.endIndex))))
                    self.translate(kizunaAbility, key: "kizunaAbility")
                    
                case 27:
                    self.dict.updateValue(self.getTavern(attribute), forKey: "tavern")
                    
                default:
                    break
                }
                
                
            }
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
            for (key, value) in self.dict {
                print(key, value)
            }
        
        
    }
    
    func downloadArcana() {
        
        // TODO: Check if the page has #ui_wikidb. If it does, it is the new page, if it doesn't, it is the old page.
       // for url in urls {

            let encodedString = "幸運に導く戦士ニンファ".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")
                
            print("ABOUT TO PARSE \(encodedURL!)")
                
            do {
                let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
                
                if html.containsString("#ui_wikidb") {
                    downloadAttributes("new", html: html)
                }
                
                else {
                    downloadAttributes("old", html: html)
                }
                

            }
       
            catch {
                print(error)
            }
            
            //self.uploadArcana()
        //}
    }
    
    func translate(value: String, key: String) {
        
        dispatch_group_enter(group)
        
        let encodedString = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        if let encodedString = encodedString {
            
//            let semaphore = dispatch_semaphore_create(0)
            
            let url = NSURL(string: "https://www.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(encodedString)&source=ja&target=ko")
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) in
                
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    if let translatedText = json["data"]["translations"][0]["translatedText"].string {
                        // gets rid of &quot
                        print("TRANSLATED TEXT : \(translatedText)")
                        self.dict.updateValue(translatedText, forKey: key)
                        dispatch_group_leave(self.group)
//                        dispatch_semaphore_signal(semaphore)
                    }
                    
                }
            })
            task.resume()
            
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
        

    }
    
    func uploadArcana() {
        let ref = FIREBASE_REF.child("arcana")
        for (key,value) in dict {
            print("\(key)   \(value)")
        }
        print("STARTING UPLOAD PROCESS")
        let id = ref.childByAutoId().key
        // translate, put korean in dict values.
        
        // TODO: check skillcount. if 1, just do normal. if 2 or 3, just upload the single skill2 or skill3 key-values.
        
        
        // Base Case: only 1 skill, 1 ability
        guard let nKR = dict["nameKR"], let nnKR = dict["nickKR"], let nJP = dict["nameJP"], let nnJP = dict["nickJP"], let r = dict["rarity"], let g = dict["group"], let a = dict["affiliation"], let c = dict["cost"], let w = dict["weapon"], let kN = dict["kizunaName"], let kC = dict["kizunaCost"], let kA = dict["kizunaAbility"], let sC = dict["skillCount"], let sN1 = dict["skillName1"], let sM1 = dict["skillMana1"], let sD1 = dict["skillDesc1"], let aN1 = dict["abilityName1"], let aD1 = dict["abilityDesc1"] else {
            
            print("ARCANA DICTIONARY VALUE IS NIL")
            return
        }
        
        guard let imageURL = dict["imageURL"] else {
            print("COULD NOT GET IMAGEURL FROM DICT")
            return
        }
        
        guard let iconURL = dict["iconURL"] else {
            print("COULD NOT GET ICONURL FROM DICT")
            return
        }
        
        
        let arcanaOneSkill = ["uid" : "\(id)", "nameKR" : "\(nKR)", "nickKR" : "\(nnKR)", "nameJP" : "\(nJP)", "nickJP" : "\(nnJP)", "rarity" : "\(r)", "class" : "\(g)", "tavern" : "tavern", "affiliation" : "\(a)", "cost" : "\(c)", "weapon" : "\(w)", "kizunaName" : "\(kN)", "kizunaCost" : "\(kC)", "kizunaAbility" : "\(kA)", "skillCount" : "\(sC)", "skillName1" : "\(sN1)", "skillMana1" : "\(sM1)", "skillDesc1" : "\(sD1)", "abilityName1" : "\(aN1)", "abilityDesc1" : "\(aD1)", "numberOfViews" : 0, "imageURL" : "\(imageURL)", "iconURL" : "\(iconURL)"]
        
        let arcanaRef = ["\(id)" : arcanaOneSkill]

        
        ref.updateChildValues(arcanaRef, withCompletionBlock: { completion in
            print("UPLOADED ARCANA")
            
            // Check if arcana has 2 abilities
            if r.containsString("5") || r.containsString("4") {
                guard let aN2 = self.dict["abilityName2"], let aD2 = self.dict["abilityDesc2"] else {
                    return
                }
                
                let newArcanaRef = FIREBASE_REF.child("arcana/\(id)")
                let abilityRef = ["abilityName2" : "\(aN2)", "abilityDesc2" : "\(aD2)"]
                
                // Upload Ability 2
                newArcanaRef.updateChildValues(abilityRef, withCompletionBlock: { completion in
                    
                    // Check if arcana has at least 2 skills
                    if let sN2 = self.dict["skillName2"], let sM2 = self.dict["skillMana2"], let sD2 = self.dict["skillDesc2"] {
                        
                        switch (sC) {
                        case "2":
                            
                            let skill2 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)"]
                            newArcanaRef.updateChildValues(skill2)
                            
                        case "3":
                            
                            if let sN2 = self.dict["skillName2"], let sM2 = self.dict["skillMana2"], let sD2 = self.dict["skillDesc2"], let sN3 = self.dict["skillName3"], let sM3 = self.dict["skillMana3"], let sD3 = self.dict["skillDesc3"] {
                                let skill3 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)", "skillName3" : "\(sN3)", "skillMana3" : "\(sM3)", "skillDesc3" : "\(sD3)"]
                                newArcanaRef.updateChildValues(skill3)
                            }
                            
                        default:
                            break
                            
                        }

                    }

                })

            }
        })
        
    }
    
    func getRarity(string: String) -> String {
        
        switch string {
            
        case "★★★★★SSR":
            return "5★"
        case "★★★★SR":
            return "4★"
        case "★★★R":
            return "3★"
        case "★★HN":
            return "2★"
        case "★N":
            return "1★"
        default:
            return "0"
        }
        
    }
    
    func getClass(string: String) -> String {
        
        switch string {
            
        case "戦士":
            return "전사"
        case "騎士":
            return "기사"
        case "弓使い":
            return "궁수"
        case "魔法使い":
            return "법사"
        case "僧侶":
            return "승려"
        default:
            return ""
        }
        
    }
    
    func getTavern(string: String) -> String {
        
        let taverns = ["副都", "聖都", "賢者の塔", "迷宮山脈", "砂漠の湖都", "精霊島", "炎の九領", "海風の港", "夜明けの大海", "ケ者の大陸", "罪の大陸", "薄命の大陸", "鉄煙の大陸", "書架", "レムレス島", "魔神", "ガチャ", "グ交換"]
        var tav = ""
        
        for (index, t) in taverns.enumerate() {
            if string.containsString(t) {
                tav = taverns[index]
                break
            }
        }
        
        switch tav {
            
        case "副都":
            return "부도"
        case "聖都":
            return "성도"
        case "賢者の塔":
            return "현자의탑"
        case "迷宮山脈":
            return "미궁산맥"
        case "砂漠の湖都":
            return "호수도시"
        case "精霊島":
            return "정령섬"
        case "炎の九領":
            return "화염구령"
        case "海風の港":
            return "해풍의항구"
        case "夜明けの大海":
            return "새벽대해"
        case "ケ者の大陸":
            return "개들의대륙"
        case "罪の大陸":
            return "죄의대륙"
        case "薄命の大陸":
            return "박명의대륙"
        case "鉄煙の大陸":
            return "철연의대륙"
        case "年代記の大陸":
            return "연대기의대륙"
        case "レムレス島":
            return "레무레스섬"
        case "魔神":
            return "마신"
        case "義勇軍":
            return "의용군"
        case "ガチャ":
            return "링가챠"
        case "グ交換":
            return "링교환"
        default:
            return ""
        }
        
    }

    func getAffiliation(string: String) -> String {
        
        switch string {
        case "副都":
            return "부도"
        case "聖都":
            return "성도"
        case "賢者の塔":
            return "현자의탑"
        case "迷宮山脈":
            return "미궁산맥"
        case "砂漠の湖都":
            return "호수도시"
        case "精霊島":
            return "정령섬"
        case "九領":
            return "화염구령"
        case "大海":
            return "대해"
        case "ケ者の大陸":
            return "개들의대륙"
        case "罪の大陸":
            return "죄의대륙"
        case "薄命の大陸":
            return "박명의대륙"
        case "鉄煙の大陸":
            return "철연의대륙"
        case "年代記の大陸":
            return "연대기의대륙"
        case "レムレス島":
            return "레무레스섬"
        case "魔神":
            return "마신"
        case "旅人":
            return "여행자"
        case "義勇軍":
            return "의용군"
            
        default:
            return ""
        }
        
    }
    
    func getWeapon(string: String) -> String {
        
        let s = string[string.startIndex]
        switch s {
            
        case "斬":
            return "검"
        case "打":
            return "봉"
        case "突":
            return "창"
        case "弓":
            return "궁"
        case "魔":
            return "마"
        case "聖":
            return "성"
        case "拳":
            return "권"
        case "銃":
            return "총"
        case "狙":
            return "저"

        default:
            return "0"
        }
        
    }

    func downloadIconAndNames(string: String) {
        print("downloadIconAndNames- DONT EVER COME HERE")

        let path = NSBundle.mainBundle().pathForResource(".//arcanaData", ofType: "txt")
        let file = try? NSString(contentsOfFile: path! as String, encoding: NSUTF8StringEncoding)
        let data: NSData? = NSData(contentsOfFile: path!)
        do {
            let jsonObject : AnyObject! =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            let json = JSON(jsonObject)
            
            
            for (_, subJson) : (String, JSON) in json["array"] {
                if string.containsString(subJson["name"].stringValue) {
                    let arcanaID = subJson["No"].stringValue
                    print("FOUND ID # \(arcanaID)")
                    self.dict.updateValue("http://chaincrers.webcrow.jp/icon/\(arcanaID).jpg", forKey: "iconURL")
                    
                    // Upload to firebase
                    let ref = FIREBASE_REF.child("arcana")
                    ref.observeEventType(.ChildChanged, withBlock: { snapshot in
                        print(snapshot)
                        //ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        let iconURL = snapshot.value!["iconURL"] as! String
                        let url = NSURL(string: iconURL)
                        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print("DOWNLOAD ICON ERROR")
                            }
                            
                            if let data = data {
                                print("DOWNLOADED ICON!")
                                // upload to firebase storage.
                                
                                let arcanaIconRef = STORAGE_REF.child("image/arcana/\(snapshot.value!["uid"] as! String)/icon.jpg")
                                
                                arcanaIconRef.putData(NSData(data: data), metadata: nil) { metadata, error in
                                    if (error != nil) {
                                        print("ERROR OCCURED WHILE UPLOADING IMAGE")
                                        // Uh-oh, an error occurred!
                                    } else {
                                        // Metadata contains file metadata such as size, content-type, and download URL.
                                        print("UPLOADED ICON")
                                        //let downloadURL = metadata!.downloadURL
                                    }
                                }
                                
                            }
                            
                        })
                        task.resume()
                    })

                    break
                }
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func getAttributes(string: String) {
        print("SEARCHING FOR \(string)")
        
        let path = NSBundle.mainBundle().pathForResource(".//arcanaData", ofType: "txt")
        let file = try? NSString(contentsOfFile: path! as String, encoding: NSUTF8StringEncoding)
        let data: NSData? = NSData(contentsOfFile: path!)
        //print(data)
        do {
            let jsonObject : AnyObject! =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            let json = JSON(jsonObject)
            //print(json)
            
            for (_, subJson) : (String, JSON) in json["array"] {
                if string.containsString(subJson["name"].stringValue) {
                    
                    let nameJP = subJson["name"].stringValue
                    let nickJP = subJson["nickname"].stringValue
                    print(nameJP, nickJP)
                    self.translate(nameJP, key: "nameKR")
                    self.translate(nickJP, key: "nickKR")
                    let arcanaID = subJson["No"].stringValue
                    print("FOUND ID # \(arcanaID) NAME \(nickJP)")
                    
                    self.dict.updateValue("\(nameJP)", forKey: "nameJP")
                    self.dict.updateValue("\(nickJP)", forKey: "nickJP")
                    self.dict.updateValue("http://chaincrers.webcrow.jp/icon/\(arcanaID).jpg", forKey: "iconURL")
                    
                    // Upload to firebase
                    let ref = FIREBASE_REF.child("arcana")
                    ref.observeEventType(.ChildChanged, withBlock: { snapshot in
                        print(snapshot)
                        //ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        let iconURL = snapshot.value!["iconURL"] as! String
                        let url = NSURL(string: iconURL)
                        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print("DOWNLOAD ICON ERROR")
                            }
                            
                            if let data = data {
                                print("DOWNLOADED ICON!")
                                // upload to firebase storage.
                                
                                let arcanaIconRef = STORAGE_REF.child("image/arcana/\(snapshot.value!["uid"] as! String)/icon.jpg")
                                
                                arcanaIconRef.putData(NSData(data: data), metadata: nil) { metadata, error in
                                    if (error != nil) {
                                        print("ERROR OCCURED WHILE UPLOADING IMAGE")
                                        // Uh-oh, an error occurred!
                                    } else {
                                        // Metadata contains file metadata such as size, content-type, and download URL.
                                        print("UPLOADED ICON")
                                        //let downloadURL = metadata!.downloadURL
                                    }
                                }
                                
                            }
                            
                        })
                        task.resume()
                    })
                    
                    break
                }
            }
            
        } catch {
            print(error)
        }
        
    }
    func retrieveURLS() {
        
        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        
        
        
        //print("SEARCHING FOR \(string)")
        
        let path = NSBundle.mainBundle().pathForResource(".//arcanaData", ofType: "txt")
        let file = try? NSString(contentsOfFile: path! as String, encoding: NSUTF8StringEncoding)
        let data: NSData? = NSData(contentsOfFile: path!)
        
        do {
            let jsonObject : AnyObject! =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            let json = JSON(jsonObject)
            
            
            for (_, subJson) : (String, JSON) in json["array"] {
                let nameJP = subJson["name"].stringValue
                let nickJP = subJson["nickname"].stringValue
                //print("FOUND NAME \(nickJP)\(nameJP)")
                
                let arcanaURL = nickJP+nameJP
                self.urls.append(arcanaURL)
//                let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
//                let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")

            }
        } catch {
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // retrieveURLS()
//        for i in urls {
//            print(i)
//        }
        //let json = JSON(data: )
        //handleImage()
        //downloadTavern()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        
        downloadArcana()
//        for (index, u) in urls.enumerate() {
//            print(index, u)
//            
//        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func indexOf(string: String) -> String.Index? {
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex
    }
    
    init(htmlEncodedString: String) {
        do {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.init(attributedString.string)
        } catch {
            fatalError("Unhandled error: \(error)")
        }
    }
    
    func deleteHTMLTag(tag:String) -> String {
        return self.stringByReplacingOccurrencesOfString("(?i)</?\(tag)\\b[^<]*>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
    
    
}
