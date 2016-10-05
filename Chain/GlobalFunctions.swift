//
//  GlobalFunctions.swift
//  Chain
//
//  Created by Jitae Kim on 9/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation

func convertTavern(tavern: String) -> String {
    
    switch tavern {
        
    case "부도시":
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

    default:
        return ""
    }
}

//let affiliation = ["여행자", "마신", "부도", "성도", "현탑", "미궁", "호도", "정령섬", "구령", "대해", "수인", "죄", "박명", "철연", "연대기", "서가", "레무", "의용군", "화격단"]
func fullAffiliationName(affiliation: String) -> String {
    
    switch affiliation {

    case "현탑":
        return "현자의탑"
    case "미궁":
        return "미궁"
    case "호도":
        return "호수도시"
    case "레무":
        return "레무레스섬"
        
    default:
        return affiliation
    }
    
}