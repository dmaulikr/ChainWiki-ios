//
//  ArcanaAttributeConverter.swift
//  Chain
//
//  Created by Jitae Kim on 6/13/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaAttributeConverter: NSObject {
    
    static let converter = ArcanaAttributeConverter()
    
    func getRarity(_ string: String) -> String {
        
        switch string {
            
        case "★★★★★SSR", "SSR":
            return "5"
        case "★★★★SR", "SR":
            return "4"
        case "★★★R", "R":
            return "3"
        case "★★HN", "HN":
            return "2"
        case "★N", "N":
            return "1"
        default:
            return "0"
        }
        
    }
    
    func getClass(_ string: String) -> String {
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
    
    func getTavern(_ string: String) -> String {
        
        let taverns = ["副都", "聖都", "賢者の塔", "迷宮山脈", "湖都", "精霊島", "炎の九領", "海風の港", "夜明けの大海", "ケ者の大陸", "罪の大陸", "薄命の大陸", "鉄煙の大陸", "年代記", "書架", "レムレス島", "華撃団", "魔神", /*"ガチャ",*/ "グ交換", "聖王国"]
        var tav = ""
        
        for (index, t) in taverns.enumerated() {
            if string.contains(t) {
                if string.contains("3部") && t != "聖王国" {
                    tav = "\(taverns[index])2"
                }
                else {
                    tav = taverns[index]
                }
                
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
        case "湖都":
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
            return "수인의대륙"
        case "罪の大陸":
            return "죄의대륙"
        case "薄命の大陸":
            return "박명의대륙"
        case "鉄煙の大陸":
            return "철연의대륙"
        case "年代記":
            return "연대기대륙"
        case "書架":
            return "서가"
        case "レムレス島":
            return "레무레스섬"
        case "華撃団":
            return "화격단"
        case "魔神":
            return "마신"
        case "義勇軍":
            return "의용군"
        case "リングガチャ":
            return "링가챠"
        case "グ交換":
            return "링교환"
            
        // 3부 주점
        case "聖王国":
            return "성왕국"
        case "賢者の塔2":
            return "현자의탑 3부"
        case "湖都2":
            return "호수도시 3부"
        case "精霊島2":
            return "정령섬 3부"
        case "炎の九領2":
            return "화염구령 3부"
        default:
            return ""
        }
        
    }
    
    func getTavernRef(tavern: String) -> String {
        
        switch tavern {
            
        case "부도":
            return "capital"
        case "성도":
            return "holy"
        case "현자의탑":
            return "sage"
        case "미궁산맥":
            return "maze"
        case "호수도시":
            return "lake"
        case "정령섬":
            return "soul"
        case "화염구령":
            return "fire"
        case "해풍의항구":
            return "seaBreeze"
        case "새벽대해":
            return "daybreakOcean"
        case "수인의대륙":
            return "beast"
        case "죄의대륙":
            return "sin"
        case "박명의대륙":
            return "ephemerality"
        case "철연의대륙":
            return "iron"
        case "연대기대륙":
            return "chronicle"
        case "서가":
            return "book"
        case "레무레스섬":
            return "lemures"
        case "마신":
            return "demon"
        case "링가챠":
            return "ringGacha"
        case "링교환":
            return "ringChange"
        default:
            return ""
        }
        
    }
    
    func getAffiliation(_ string: String) -> String {
        // two types, second is for old arcana in text file
        switch string {
        case "副都":
            return "부도"
        case "聖都":
            return "성도"
        case "賢者の塔", "賢者":
            return "현자의탑"
        case "迷宮山脈", "迷宮":
            return "미궁산맥"
        case "湖都":
            return "호수도시"
        case "精霊島", "海風":
            return "정령섬"
        case "九領":
            return "화염구령"
        case "大海":
            return "대해"
        case "ケ者の大陸", "ケ者":
            return "수인의대륙"
        case "罪の大陸", "罪":
            return "죄의대륙"
        case "薄命の大陸", "薄命":
            return "박명의대륙"
        case "鉄煙の大陸", "鉄煙":
            return "철연의대륙"
        case "年代記の大陸":
            return "연대기대륙"
        case "レムレス島":
            return "레무레스섬"
        case "華撃団":
            return "화격단"
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
    
    func getWeapon(_ string: String) -> String {
        
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
    
}

extension String {
    
    func fixEmptyString(rarity: String) -> String {
        
        switch rarity {
        case "1":
            return "1"
        case "2":
            return "1"
        case "3":
            return "2"
        case "4":
            return "3"
        case "5":
            return "4"
        default:
            return "0"
        }
    }
    
}
