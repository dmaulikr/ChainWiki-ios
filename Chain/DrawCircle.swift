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
    { layer.cornerRadius = bounds.size.width/2; }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//    
//        var path = UIBezierPath(ovalInRect: CGRectInset(CGRect(x: 0, y: 0, width: 30, height: 30), 2, 2))
//        path.fill()
//        UIColor.greenColor().setStroke()
//        path.stroke()
//        
//        let clippingPath = path.copy() as! UIBezierPath
//        clippingPath.addCurveToPoint(CGPoint(x:self.bounds.width/2, y:0), controlPoint1: CGPoint(x:self.bounds.width/2, y:self.bounds.height/2), controlPoint2: CGPoint(x:self.bounds.width/2, y:self.bounds.height/2))
//        clippingPath.closePath()
//        
//        clippingPath.addClip()
//        
//        //2 - get the current context
//        let context = UIGraphicsGetCurrentContext()
//        let colors = [UIColor.greenColor().CGColor, UIColor.whiteColor().CGColor]
//        
//        //3 - set up the color space
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        
//        //4 - set up the color stops
//        let colorLocations:[CGFloat] = [0.0, 1.0]
//        
//        //5 - create the gradient
//        let gradient = CGGradientCreateWithColors(colorSpace,
//                                                  colors,
//                                                  colorLocations)
//        
//        //6 - draw the gradient
//        var startPoint = CGPoint(x:self.bounds.width/2, y:self.bounds.height)
//        var endPoint = CGPoint(x:self.bounds.width/2, y: 0)
//        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation)
//    }
    
    

}
