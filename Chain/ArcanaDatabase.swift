//
//  ArcanaDatabase.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Kanna
import Polyglot

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
                                    print(text)
                                    break findingTable
                                }
                            }
                        }
                        
                    }

                }
                
                dict.updateValue(textWithWeapon, forKey: "weapon")
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
                var numberOfSkills = 1
                
                if !html.containsString("SKILL 2") {    // Only has 1 skill
                    
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
                                print(a.text)
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                // TODO: translate each before adding to dictionary.
                                switch attIndex {
                                case 0:
                                    self.dict.updateValue(attribute, forKey: "nameJP")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "rarity")
                                case 3:
                                    self.dict.updateValue(attribute, forKey: "group")
                                case 4:
                                    self.dict.updateValue(attribute, forKey: "affiliation")
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
                                print(a)
                                // TODO: translate each before adding to dictionary.
                                switch attIndex {
                                    
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "kizunaName")
                                case 2:
                                    self.dict.updateValue(attribute, forKey: "kizunaCost")
                                case 3:
                                    self.dict.updateValue(attribute, forKey: "kizunaAbility")
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
                                    self.dict.updateValue(attribute, forKey: "skillName1")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana1")
                                case 2:
                                    self.dict.updateValue(attribute, forKey: "skillDesc1")
                                default:
                                    break
                                }
                            }
                        
                            // Skip cases 4,5 if only one skill
                            
                        case 4: // Skill 2
                            if numberOfSkills == 1 {
                                // Just get ability 1
                                
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        self.dict.updateValue(attribute, forKey: "abilityName1")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "abilityDesc1")
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
                                    self.dict.updateValue(attribute, forKey: "skillName2")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana2")
                                case 2:
                                    self.dict.updateValue(attribute, forKey: "skillDesc2")
                                default:
                                    break
                                }
                            }
                            
                        case 5:
                            
                            switch numberOfSkills {
                                
                            case 1:
                                // Just get ability 2
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        self.dict.updateValue(attribute, forKey: "abilityName2")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "abilityDesc2")
                                    default:
                                        break
                                    }
                                }
                                break
                                
                            case 2:
                                // Just get ability 1
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        self.dict.updateValue(attribute, forKey: "abilityName1")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                                break
                                
                            default:
                                
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    // TODO: translate each before adding to dictionary.
                                    switch attIndex {
                                        
                                    case 0:
                                        self.dict.updateValue(attribute, forKey: "skillName3")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "skillMana3")
                                    case 2:
                                        self.dict.updateValue(attribute, forKey: "skillDesc3")
                                    default:
                                        break
                                    }
                                }
                            }
  
                            

                            
                        case 6:
                            
                            guard numberOfSkills == 3 else {
                                print("ONLY 1 OR 2 SKILL, DON'T COME THIS FAR")
                                if numberOfSkills == 1 {
                                    break
                                }
                                else { // numberofskills 2, get ability 2
                                    let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                    
                                    for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                        guard let attribute = a.text else {
                                            return
                                        }
                                        // TODO: translate each before adding to dictionary.
                                        switch attIndex {
                                            
                                        case 0:
                                            self.dict.updateValue(attribute, forKey: "abilityName2")
                                        case 1:
                                            self.dict.updateValue(attribute, forKey: "abilityDesc2")
                                        default:
                                            break
                                        }
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
                                    self.dict.updateValue(attribute, forKey: "abilityName1")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "abilityDesc1")
                                default:
                                    break
                                }
                            }
                            
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
                                    self.dict.updateValue(attribute, forKey: "abilityName2")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "abilityDesc2")
                                default:
                                    break
                                }
                            }
                        default:
                        break
                        }

                        
                       
                        
                        // TODO: Filter needed attributes, then append to attributeValues.
//                        if index >= 41 {
//                            break // Don't need attributes after this point
//                        }
                        
                        
                        if let attribute = link.text {
                           // if (self.requiredAttributes.contains(index)) {
                                
                                // TODO: Need to setValue Dictionary.
                                self.attributeValues.append(attribute)
                            //}
                            
                            //print(attribute)
                        }
                    }
                    
                    // After fetching, print array
                    dispatch_async(dispatch_get_main_queue()) {
                        for i in self.dict {
                            print(i)
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
    
    func translate() {
        let translator = Polyglot(clientId: "ChainChronicle1126", clientSecret: "hCRxD8K8n4SkJ+m/yQtV1cFxm/JG4JfjzMFptQSBwWE=")
        translator.fromLanguage = Language.Japanese
        translator.toLanguage = Language.Korean
        
        let text = "敵陣で発動すると目の前の敵１体に連続攻撃によるダメージを10回（0.5倍×10回）与えた後、小ダメージ（4倍）を与える。"
        
        
        translator.translate(text) { translation in
            print(translation)
        }
    }
    
    func uploadArcana() {
        let ref = FIREBASE_REF.child("arcana")
        
        let id = ref.childByAutoId().key

        print("beee is unwrapped")
        guard let nJP = dict["nameJP"], let r = dict["rarity"], let g = dict["group"], let a = dict["affiliation"], let c = dict["cost"], let w = dict["weapon"], let kN = dict["kizunaName"], let kC = dict["kizunaCost"], let kA = dict["kizunaAbility"], let sN1 = dict["skillName1"], let sM1 = dict["skillMana1"], let sD1 = dict["skillDesc1"], let sN2 = dict["skillName2"], let sM2 = dict["skillMana2"], let sD2 = dict["skillDesc2"], let sN3 = dict["skillName3"], let sM3 = dict["skillMana3"], let sD3 = dict["skillDesc3"], let aN1 = dict["abilityName1"], let aD1 = dict["abilityDesc1"],  let aN2 = dict["abilityName2"], let aD2 = dict["abilityDesc2"] else {
            print("DICTIONARY IS NOT UNWRAPPED")
            return
        }
        
//        guard let u = snapshot.value!["uid"] as? String, let nKR = snapshot.value!["nameKR"] as? String, let nJP = snapshot.value!["nameJP"] as? String, let r = snapshot.value!["rarity"] as? String, let g = snapshot.value!["class"] as? String, let t = snapshot.value!["tavern"] as? String, let a = snapshot.value!["affiliation"] as? String, let c = snapshot.value!["cost"] as? String, let w = snapshot.value!["weapon"] as? String, let kN = snapshot.value!["kizunaName"] as? String, let kC = snapshot.value!["kizunaCost"] as? String, let kA = snapshot.value!["kizunaAbility"] as? String, let sC = snapshot.value!["skillCount"] as? String, let sN1 = snapshot.value!["skillName1"] as? String, let sM1 = snapshot.value!["skillMana1"] as? String, let sD1 = snapshot.value!["skillDesc1"] as? String, let sN2 = snapshot.value!["skillName2"] as? String, let sM2 = snapshot.value!["skillMana2"] as? String, let sD2 = snapshot.value!["skillDesc2"] as? String, let sN3 = snapshot.value!["skillName3"] as? String, let sM3 = snapshot.value!["skillMana3"] as? String, let sD3 = snapshot.value!["skillDesc1"] as? String, let aN1 = snapshot.value!["abilityName1"] as? String, let aD1 = snapshot.value!["abilityDesc1"] as? String, let aN2 = snapshot.value!["abilityName2"] as? String, let aD2 = snapshot.value!["abilityDesc2"] as? String, let v = snapshot.value!["numberOfViews"] as? Int {
//            
//        }
        let arcana = Arcana(u: id, nKR: "한글 이름", nJP: "OI", r: "\(dict["rarity"])", g: "\(dict["group"])", t: "얻는 장소", a: "\(dict["affiliation"])", c: "\(dict["cost"])", w: "\(dict["weapon"])", kN: "\(dict["kizunaName"])", kC: "\(dict["kizunaCost"])", kA: "\(dict["kizunaAbility"])", sC: "3", sN1: "\(dict["skillName1"])", sM1: "\(dict["skillMana1"])", sD1: "\(dict["skillDesc1"])", sN2: "\(dict["skillName2"])", sM2: "\(dict["skillMana2"])", sD2: "\(dict["skillDesc2"])", sN3: "\(dict["skillName2"])", sM3: "\(dict["skillMana3"])", sD3: "\(dict["skillDesc3"])", aN1: "\(dict["abilityName1"])", aD1: "\(dict["abilityDesc1"])", aN2: "\(dict["abilityName2"])", aD2: "\(dict["abilityName2"])", v : 1)
        
        guard let arc = arcana else {
            print("arc is not arcana")
                return
        }
 
        
        let arcanaDetail = ["uid" : "\(arc.uid)", "nameKR" : "\(arc.nameKR)", "nameJP" : "\(arc.nameJP)", "rarity" : "\(arc.rarity)", "class" : "\(arc.group)", "tavern" : "\(arc.tavern)", "affiliation" : "\(arc.affiliation)", "cost" : "\(arc.cost)", "weapon" : "\(arc.weapon)", "kizunaName" : "\(arc.kizunaName)", "kizunaCost" : "\(arc.kizunaCost)", "kizunaAbility" : "\(arc.kizunaAbility)", "skillCount" : "\(arc.skillCount)", "skillName1" : "\(arc.skillName1)", "skillMana1" : "\(arc.skillMana1)", "skillDesc1" : "\(arc.skillDesc1)", "skillName2" : "\(arc.skillName2)", "skillMana2" : "\(arc.skillMana2)", "skillDesc2" : "\(arc.skillDesc2)", "skillName3" : "\(arc.skillName3)", "skillMana3" : "\(arc.skillMana3)", "skillDesc3" : "\(arc.skillDesc3)", "abilityName1" : "\(arc.abilityName1)", "abilityDesc1" : "\(arc.abilityDesc1)", "abilityName2" : "\(arc.abilityName2)", "abilityDesc2" : "\(arc.abilityDesc2)", "numberOfViews" : "\(arc.numberOfViews)"]
        
        
        
        let arcanaRef = ["\(id)" : arcanaDetail]
        ref.updateChildValues(arcanaRef)
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
            return "참"
        case "打":
            return "타"
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
}