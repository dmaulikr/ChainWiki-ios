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
    //var firebaseNSArray =
//    let requiredAttributes = [1, 2, 4, 5, 8, 11, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40]
    var dict: [String : String]?
    var arcanaID: Int?
    
    
    

    
    func downloadArcana() {
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
                
                
                let requiredAttributes = [1, 2, 4, 5, 8, 11, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40]
                var skillIndex = 0
                switch numberOfSkills {
                case 1:
                    skillIndex = 1
                case 2:
                    break
                default:    // 3 skills
                    break
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
                //td[@class='   ']    This doesn't get skills #3 title. TODO: individually get skill #3 title?
                //span[@data-jscol_sort]"   This gets skill #3 title, but not skill descriptions.
                
                // Number of tables.
                //tbody
                
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
                        //print(link.text!)
                        if index == 0 {
                            
                            if let att = Kanna.HTML(html: link.text!, encoding: NSUTF8StringEncoding) {
                                for a in att.xpath("//*") {
                                    print(a.text)
                                }
                            }

                            
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
        
        
//        let arcana = Arcana(u: id, nKR: "한글 이름", nJP: attributeValues[0], r: attributeValues[1], g: attributeValues[2], t: "얻는 장소", a: attributeValues[3], c: attributeValues[4], w: attributeValues[5], kN: attributeValues[6], kC: attributeValues[7], kA: attributeValues[8], sC: "3", sN1: attributeValues[9], sM1: attributeValues[10], sD1: attributeValues[11], sN2: attributeValues[12], sM2: attributeValues[13], sD2: attributeValues[14], sN3: attributeValues[15], sM3: attributeValues[16], sD3: "SKILL 3", aN1: attributeValues[17], aD1: attributeValues[18], aN2: attributeValues[19], aD2: attributeValues[20], v : 1)
        
        
        let arcana = Arcana(u: id, nKR: "한글 이름", nJP: attributeValues[0], r: "5성", g: attributeValues[2], t: "얻는 장소", a: attributeValues[3], c: attributeValues[4], w: attributeValues[5], kN: attributeValues[6], kC: attributeValues[7], kA: attributeValues[8], sC: "3", sN1: attributeValues[9], sM1: attributeValues[10], sD1: attributeValues[11], sN2: attributeValues[12], sM2: attributeValues[13], sD2: attributeValues[14], sN3: attributeValues[15], sM3: attributeValues[16], sD3: "SKILL 3 Desc", aN1: attributeValues[17], aD1: attributeValues[18], aN2: attributeValues[19], aD2: attributeValues[20], v : 1)
        
        guard let a = arcana
            else {
                return
        }
 
        
        let arcanaDetail = ["uid" : "\(a.uid)", "nameKR" : "\(a.nameKR)", "nameJP" : "\(a.nameJP)", "rarity" : "\(a.rarity)", "class" : "\(a.group)", "tavern" : "\(a.tavern)", "affiliation" : "\(a.affiliation)", "cost" : "\(a.cost)", "weapon" : "\(a.weapon)", "kizunaName" : "\(a.kizunaName)", "kizunaCost" : "\(a.kizunaCost)", "kizunaAbility" : "\(a.kizunaAbility)", "skillCount" : "\(a.skillCount)", "skillName1" : "\(a.skillName1)", "skillMana1" : "\(a.skillMana1)", "skillDesc1" : "\(a.skillDesc1)", "skillName2" : "\(a.skillName2)", "skillMana2" : "\(a.skillMana2)", "skillDesc2" : "\(a.skillDesc2)", "skillName3" : "\(a.skillName3)", "skillMana3" : "\(a.skillMana3)", "skillDesc3" : "\(a.skillDesc3)", "abilityName1" : "\(a.abilityName1)", "abilityDesc1" : "\(a.abilityDesc1)", "abilityName2" : "\(a.abilityName2)", "abilityDesc2" : "\(a.abilityDesc2)", "numberOfViews" : "\(a.numberOfViews)"]
        
        
        
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