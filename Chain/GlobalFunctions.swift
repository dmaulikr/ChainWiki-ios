//
//  GlobalFunctions.swift
//  Chain
//
//  Created by Jitae Kim on 9/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

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

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}

extension Date {
    struct Formatters {
        static let custom: DateFormatter = {
            let formatter = DateFormatter()
            return formatter
        }()
        static let date:DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        static let time:DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        static let weekday: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "cccc"
            return formatter
        }()
        static let month: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "LLLL"
            return formatter
        }()
    }
    var date: String {
        return Formatters.date.string(from: self)
    }
    var time: String {
        return Formatters.time.string(from: self)
    }
    var weekdayName: String {
        return Formatters.weekday.string(from: self)
    }
    var monthName: String {
        return Formatters.month.string(from: self)
    }
    func formatted(with dateFormat: String) -> String {
        Formatters.custom.dateFormat = dateFormat
        return Formatters.custom.string(from: self)
    }
}

extension String {
    func toDateFormatted(with dateFormat:String)-> Date? {
        Date.Formatters.custom.dateFormat = dateFormat
        return Date.Formatters.custom.date(from: self)
    }
}
