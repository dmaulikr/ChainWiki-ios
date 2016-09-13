//
//  DrawCircle.swift
//  Chain
//
//  Created by Jitae Kim on 9/12/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
@IBDesignable
class DrawCircle: UIView {

    override func layoutSubviews()
    {
        layer.cornerRadius = bounds.size.width/2
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 1.0]
        
        let colors = [UIColor.whiteColor().CGColor,
                      UIColor.blueColor().CGColor]
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradientCreateWithColors(colorspace,
                                                  colors, locations)
        
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        startPoint.x = self.bounds.width/4
        startPoint.y = self.bounds.height/4
        endPoint.x = self.bounds.width/2
        endPoint.y = self.bounds.height/2
        let startRadius: CGFloat = 0
        let endRadius: CGFloat = 30
        
        CGContextDrawRadialGradient (context, gradient, startPoint,
                                     startRadius, endPoint, endRadius,
                                     CGGradientDrawingOptions.DrawsBeforeStartLocation)
    }
    
    

}
