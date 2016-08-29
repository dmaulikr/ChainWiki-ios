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
    let requiredAttributes = [1, 2, 4, 5, 8, 11, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40]
    var dict: [String : String]?
    var arcanaID: Int?
    
    func downloadArcana() {
        do {
            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
            // print(htmlSource)
            
            // Kanna, search through htmㅣ
            
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
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
                    for (index, link) in doc.xpath("//td[@class='   ']").enumerate() {
                        
                        // TODO: Filter needed attributes, then append to attributeValues.
                        if index >= 41 {
                            break // Don't need attributes after this point
                        }
                        if let attribute = link.text {
                            if (self.requiredAttributes.contains(index)) {
                                
                                // TODO: Need to setValue Dictionary.
                                self.attributeValues.append(attribute)
                            }
                            
                            //print(attribute)
                        }
                    }
                    
                    // After fetching, print array
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        print(self.attributeValues.count)
                        
//                        for i in self.attributeValues {
//                            print(i)
//                        }
                        self.uploadArcana()
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
        
        let arcana = Arcana(n: attributeValues[0], r: attributeValues[1], g: attributeValues[2], a: attributeValues[3], c: attributeValues[4], w: attributeValues[5], kN: attributeValues[6], kC: attributeValues[7], kA: attributeValues[8], sN1: attributeValues[9], sM1: attributeValues[10], sD1: attributeValues[11], sN2: attributeValues[12], sM2: attributeValues[13], sD2: attributeValues[14], sN3: attributeValues[15], sM3: attributeValues[16], sD3: "SKILL 3", aN1: attributeValues[17], aD1: attributeValues[18], aN2: attributeValues[19], aD2: attributeValues[20])
        
        
        let id = ref.childByAutoId().key
        
        guard let a = arcana
            else {
                return
        }
        let arcanaDetail = ["uid" : id, "name" : "\(a.name)" ]
        
        
        
        let arcanaRef = ["\(id)" : arcanaDetail]
        ref.updateChildValues(arcanaRef)
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