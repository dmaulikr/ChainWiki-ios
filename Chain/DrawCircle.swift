//
//  DrawCircle.swift
//  Chain
//
//  Created by Jitae Kim on 9/12/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
//@IBDesignable
class DrawCircle: UIView {

    var mana = ""
    
    override func layoutSubviews()
    {
        layer.cornerRadius = bounds.size.width/2
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    
        if mana != "" {
            let context = UIGraphicsGetCurrentContext()
            let locations: [CGFloat] = [0.0, 1.0]
            
            var gradientColor = UIColor.black
            
            
            switch mana {
            case "전사":
                gradientColor = WARRIORCOLOR
            case "기사":
                gradientColor = KNIGHTCOLOR
            case "궁수":
                gradientColor = ARCHERCOLOR
            case "법사":
                gradientColor = MAGICIANCOLOR
            case "승려":
                gradientColor = HEALERCOLOR
            default:
                gradientColor = UIColor.black
                
            }
            
            
            let colors = [UIColor.white.cgColor,
                          gradientColor.cgColor]
            
            let colorspace = CGColorSpaceCreateDeviceRGB()
            
            let gradient = CGGradient(colorsSpace: colorspace,
                                                      colors: colors as CFArray, locations: locations)
            
            let startPoint = CGPoint(x: self.bounds.width/4, y: self.bounds.height/4)
            let endPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            let startRadius: CGFloat = 0
            let endRadius: CGFloat = 7
            
            context?.drawRadialGradient (gradient!, startCenter: startPoint,
                                         startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                         options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }
        
    }
    
    

}
