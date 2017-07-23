//
//  GoogleTranslator.swift
//  Chain
//
//  Created by Jitae Kim on 6/13/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let API_KEY = "AIzaSyBD9eX7ABB0Xu1N6CnSdKL-bnsNF5WgLtc"

struct Translation: Codable {
    
    var translatedText: [String: String]
    
}

class GoogleTranslator: NSObject {
    
    static let translator = GoogleTranslator()
    
    func translate(_ value: String, group: DispatchGroup, completion: @escaping (String?) -> Void) {
        
        print("translating \(value)")
//        return
        var encodedString = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        encodedString = encodedString?.replacingOccurrences(of: "<", with:"")
        encodedString = encodedString?.replacingOccurrences(of: ">", with:"")
        
        guard let encodedURL = encodedString,
            let url = URL(string: "https://www.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(encodedURL)&source=ja&target=ko") else {
                completion(nil)
                return
        }
        group.enter()
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            if let data = data {
                
                let json = JSON(data: data)
                
                if let translation = json["data"]["translations"][0]["translatedText"].string {
                    
                    print(translation)
                    
                    // get rid of &quot; and &lt &gt;
                    var t = translation.replacingOccurrences(of: "&quot;", with: " ")
                    t = t.replacingOccurrences(of: "&lt;", with: "")
                    t = t.replacingOccurrences(of: "&gt;", with: "")
                    // some have quotes at start, so remove whitespace
                    t = t.trimmingCharacters(in: .whitespacesAndNewlines)
                    // remove double spaces
                    t = t.replacingOccurrences(of: "◆ ", with: "")
                    t = t.replacingOccurrences(of: "  ", with: " ")
                    // remove space in front of %
                    t = t.replacingOccurrences(of: " %", with: "%")
                    t = t.replacingOccurrences(of: " )", with: ")")
                    t = t.replacingOccurrences(of: "副都", with: "부도")
                    t = t.replacingOccurrences(of: "WAVE", with: "웨이브")
                    t = t.replacingOccurrences(of: "進むたび", with: "진행될때마다")
                    t = t.replacingOccurrences(of: "】", with: "]")
                    
                    group.leave()
                    completion(t)
                    
                }
                else {
                    group.leave()
                    completion(nil)
                }
                
            }
            
        })
        
        task.resume()
    }
}
