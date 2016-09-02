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

class ArcanaDatabase: UIViewController {


    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    var attributeValues = [String]()

    var dict = [String : String]()
    var arcanaID: Int?
    
    
    func downloadWeapon() {
        do {
            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
        
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {

                var textWithWeapon = ""
                // Search for nodes by XPath
                findingTable : for (index, link) in doc.xpath("//table[@id='']").enumerate() {
                    
                    let weapon = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                    
                    guard let linkText = link.text else {
                        return
                    }
                    
                    if linkText.containsString("斬") || linkText.containsString("打") || linkText.containsString("突") || linkText.containsString("弓") || linkText.containsString("魔") || linkText.containsString("聖") || linkText.containsString("拳") || linkText.containsString("銃") || linkText.containsString("狙") {
                        
                        
                        // Nested Loop. Should return right at first iteration.
                        for (weaponIndex, a) in weapon!.xpath(".//a['title']").enumerate() {
                            
                            if weaponIndex == 0 {
                                if let text = a.text {
                                    textWithWeapon.appendContentsOf(text)
                                    break findingTable
                                }
                            }
                        }
                        
                    }

                }
                
                
                dict.updateValue("\(getWeapon(textWithWeapon)) / \(textWithWeapon)", forKey: "weapon")
            }
            
        } catch {
            print("PARSING ERROR")
        }
    }

    
    func downloadArcana() {
        downloadWeapon()
        do {
            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
            // print(htmlSource)
            
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
                
                // "#id"
                //                for i in doc.css("#s") {
                //                    print(i["@scan"])
                //                }
                
                // Search for nodes by XPath
                //div[@class='ks']
                
                // Arcana Attribute Key
                //th[@class='   js_col_sort_desc ui_col_sort_asc']
                
                
                // Arcana Attribute Value
                //td[@class='   ']
                //span[@data-jscol_sort]"
                
                // Number of tables.
                //tbody
                
                //<table width="" id="ui
                
                
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    // Find Skill 3 Desc
//                    let h = html as NSString
//
//                    //let startIndex = h.rangeOfString("SKILL 3")
//                    if let startIndex = html.indexOf("SKILL 3") as? Int {
//                        print(startIndex)
//                        html.substringWithRange(Range<String.Index>(start: html.startIndex.advancedBy(startIndex), end: html.endIndex))
//                    }

                    
                    // Fetched required attributes
                    for (index, link) in doc.xpath("//tbody").enumerate() {
                        
                        // TODO: Check for the table index. Skip through unneeded tables
                        
                        switch index {
                            
                        case 0: // Arcana base info
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                // TODO: translate each before adding to
                                
                                switch attIndex {
                                case 0:
                                    self.dict.updateValue(attribute, forKey: "nameJP")
                                    self.translate(attribute, key: "nameKR")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "rarity")
                                case 3:
                                    //self.dict.updateValue(attribute, forKey: "group")
                                    self.dict.updateValue(self.getClass(attribute), forKey: "group")
                                case 4:
                                    //self.dict.updateValue(attribute, forKey: "affiliation")
                                    self.dict.updateValue(self.getAffiliation(attribute), forKey: "affiliation")
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
                                
                                // TODO: translate each before adding to dictionary.
                                switch attIndex {
                                    
                                case 1:
                                    //self.dict.updateValue(attribute, forKey: "kizunaName")
                                    self.translate(attribute, key: "kizunaName")
                                case 2:
                                    self.dict.updateValue(attribute, forKey: "kizunaCost")
                                case 3:
                                    //self.dict.updateValue(attribute, forKey: "kizunaAbility")
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
                                // TODO: translate each before adding to dictionary.
                                switch attIndex {
                                    
                                case 0:
                                    //self.dict.updateValue(attribute, forKey: "skillName1")
                                    self.translate(attribute, key: "skillName1")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana1")
                                case 2:
                                    //self.dict.updateValue(attribute, forKey: "skillDesc1")
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
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        //self.dict.updateValue(attribute, forKey: "abilityName1")
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        //self.dict.updateValue(attribute, forKey: "abilityDesc1")
                                        self.translate(attribute, key: "AbilityDesc1")
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
                                // TODO: translate each before adding to dictionary.
                                switch attIndex {
                                    
                                case 0:
                                    //self.dict.updateValue(attribute, forKey: "skillName2")
                                    self.translate(attribute, key: "skillName2")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana2")
                                case 2:
                                    //self.dict.updateValue(attribute, forKey: "skillDesc2")
                                    self.translate(attribute, key: "skillDesc2")
                                default:
                                    break
                                }
                            }
                            
                        case 5:
                            
                            switch numberOfSkills {
                                
                            case 1:
                                // Just get ability 2
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                print("ABILITY 2 TEXT")
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        //self.dict.updateValue(attribute, forKey: "abilityName2")
                                        self.translate(attribute, key: "abilityName2")
                                    case 1:
                                        
                                        //self.dict.updateValue(attribute, forKey: "abilityDesc2")
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
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        //self.dict.updateValue(attribute, forKey: "abilityName1")
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        //self.dict.updateValue(attribute, forKey: "abilityDesc1")
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
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        //self.dict.updateValue(attribute, forKey: "skillName3")
                                        self.translate(attribute, key: "skillName3")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "skillMana3")
                                    case 2:
                                        //self.dict.updateValue(attribute, forKey: "skillDesc3")
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
                                        // TODO: translate each before adding to dictionary.
                                        switch attIndex {
                                            
                                        case 0:
                                            //self.dict.updateValue(attribute, forKey: "abilityName2")
                                            self.translate(attribute, key: "abilityName2")
                                        case 1:
                                            //self.dict.updateValue(attribute, forKey: "abilityDesc2")
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
                                        // TODO: translate each before adding to dictionary.
                                        switch attIndex {
                                            
                                        case 0:
                                            //self.dict.updateValue(attribute, forKey: "abilityName1")
                                            self.translate(attribute, key: "abilityName1")
                                        case 1:
                                            //self.dict.updateValue(attribute, forKey: "abilityDesc1")
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
                                // TODO: translate each before adding to dictionary.
                                switch attIndex {
                                    
                                case 0:
                                    //self.dict.updateValue(attribute, forKey: "abilityName2")
                                    self.translate(attribute, key: "abilityName2")
                                case 1:
                                    //self.dict.updateValue(attribute, forKey: "abilityDesc2")
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
                    dispatch_async(dispatch_get_main_queue()) {
//                        for i in self.dict {
//                            print(i)
//                        }
                        for (key,value) in self.dict {
                            print("\(key)   \(value)")
                        }
                        self.uploadArcana()
                        // update some UI
//                        print(self.attributeValues.count)
//                        
//                        for i in self.attributeValues {
//                            print(i)
//                        }
                        //self.uploadArcana()
                    }
                }
                
            }
            
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        } catch {
            print("SOME OTHER ERROR")
        }
    }
    
    func translate(value: String, key: String) {
        
        let encodedString = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        if let encodedString = encodedString {
            
             let semaphore = dispatch_semaphore_create(0)
            
            let url = NSURL(string: "https://www.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(encodedString)&source=ja&target=ko")
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) in
                
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    if let translatedText = json["data"]["translations"][0]["translatedText"].string {
                        // gets rid of &quot
                        self.dict.updateValue(String(htmlEncodedString: translatedText), forKey: key)
                        dispatch_semaphore_signal(semaphore)
                    }
                    
                }
            })
            
            
            task.resume()
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
        
    }
    
    func uploadArcana() {
        let ref = FIREBASE_REF.child("arcana")
        
        let id = ref.childByAutoId().key
        // translate, put korean in dict values.
        
        // TODO: check skillcount. if 1, just do normal. if 2 or 3, just upload the single skill2 or skill3 key-values.
        
        
        // Base Case: only  1 skill
        guard let nKR = dict["nameKR"], let nJP = dict["nameJP"], let r = dict["rarity"], let g = dict["group"], let a = dict["affiliation"], let c = dict["cost"], let w = dict["weapon"], let kN = dict["kizunaName"], let kC = dict["kizunaCost"], let kA = dict["kizunaAbility"], let sC = dict["skillCount"], let sN1 = dict["skillName1"], let sM1 = dict["skillMana1"], let sD1 = dict["skillDesc1"], let aN1 = dict["abilityName1"], let aD1 = dict["abilityDesc1"],  let aN2 = dict["abilityName2"], let aD2 = dict["abilityDesc2"] else {
            
            print("ARCANA DICTIONARY VALUE IS NIL")
            return
        }
        
        
        
        let arcanaOneSkill = ["uid" : "\(id)", "nameKR" : "\(nKR)", "nameJP" : "\(nJP)", "rarity" : "\(r)", "class" : "\(g)", "tavern" : "tavern", "affiliation" : "\(a)", "cost" : "\(c)", "weapon" : "\(w)", "kizunaName" : "\(kN)", "kizunaCost" : "\(kC)", "kizunaAbility" : "\(kA)", "skillCount" : "\(sC)", "skillName1" : "\(sN1)", "skillMana1" : "\(sM1)", "skillDesc1" : "\(sD1)", "abilityName1" : "\(aN1)", "abilityDesc1" : "\(aD1)", "abilityName2" : "\(aN2)", "abilityDesc2" : "\(aD2)", "numberOfViews" : 0]
        
        let arcanaRef = ["\(id)" : arcanaOneSkill]
        
        switch (sC) {
        case "1":
            break
        default:
            guard let sN2 = dict["skillName2"], let sM2 = dict["skillMana2"], let sD2 = dict["skillDesc2"], let sN3 = dict["skillName3"], let sM3 = dict["skillMana3"], let sD3 = dict["skillDesc3"] else {
                return
            }
            ref.updateChildValues(arcanaRef, withCompletionBlock: { completion in
                // If arcana has 2 or 3 skills, update them.
                let newArcanaRef = FIREBASE_REF.child("arcana/\(id)")
                
                switch (sC) {
                case "2":
                    let skill2 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)"]
                    newArcanaRef.updateChildValues(skill2)
                case "3":
                    let skill3 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)", "skillName3" : "\(sN3)", "skillMana3" : "\(sM3)", "skillDesc3" : "\(sD3)"]
                    newArcanaRef.updateChildValues(skill3)
                default:
                    break
                    
                }
            })
        }
    }
    
    func getRarity(string: String) -> String {
        
        switch string {
            
        case "★★★★★SSR":
            return "5"
        case "★★★★SR":
            return "4"
        case "★★★R":
            return "3"
        case "★★HN":
            return "2"
        case "★N":
            return "1"
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
        case "旅人":
            return "여행자"
        case "義勇軍":
            return "의용군"
        
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
        case "炎の九領":
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        
        self.downloadArcana()
        
        
        //translate()
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
}
