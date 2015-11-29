//
//  bracketView.swift
//  floodPrototype
//
//  Created by Mark Xue on 11/28/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

class bracketView: UIView {
    
    override func drawRect(rect: CGRect) {
        
        let transparentBlue = UIColor(colorLiteralRed: 74/255,
            green: 135/255, blue: 238/255, alpha: 0.8).CGColor
        
        let size = 0.8 * min(rect.size.height, rect.size.width)
        let offset = size / 5
        let baseRectangle = CGRectMake(rect.origin.x + (rect.size.width - size)/2, rect.origin.y + (rect.size.height - size)/2, size, size)
        
        let origin = baseRectangle.origin
        let originX = CGPoint(x: baseRectangle.origin.x + baseRectangle.size.width, y: baseRectangle.origin.y)
        let originY = CGPoint(x: baseRectangle.origin.x, y: baseRectangle.origin.y + baseRectangle.size.height)
        let originXY = CGPoint(x: baseRectangle.origin.x + baseRectangle.size.width, y: baseRectangle.origin.y + baseRectangle.size.height)
        
        let path = CGPathCreateMutable()
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, transparentBlue)
        CGContextSetLineWidth(context, 5)
       
        CGPathMoveToPoint(path, nil, origin.x + offset, origin.y)
        CGPathAddLineToPoint(path, nil, origin.x, origin.y)
        CGPathAddLineToPoint(path, nil, origin.x, origin.y+offset)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, .Stroke )
        
        CGPathMoveToPoint(path, nil, originX.x - offset, originX.y)
        CGPathAddLineToPoint(path, nil, originX.x, originX.y)
        CGPathAddLineToPoint(path, nil, originX.x, originX.y+offset)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, .Stroke )
        
        CGPathMoveToPoint(path, nil, originY.x + offset, originY.y)
        CGPathAddLineToPoint(path, nil, originY.x, originY.y)
        CGPathAddLineToPoint(path, nil, originY.x, originY.y-offset)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, .Stroke )
        
        CGPathMoveToPoint(path, nil, originXY.x - offset, originXY.y)
        CGPathAddLineToPoint(path, nil, originXY.x, originXY.y)
        CGPathAddLineToPoint(path, nil, originXY.x, originXY.y - offset)
        CGContextAddPath(context, path)
        CGContextDrawPath(context, .Stroke )
        
    }

}
