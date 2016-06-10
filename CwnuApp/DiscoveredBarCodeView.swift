//
//  DiscoveredBarCodeView.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 16..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class DiscoveredBarCodeView: UIView {
    
    var borderLayer : CAShapeLayer?
    var corners : [CGPoint]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMyView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func drawBorder(points : [CGPoint]) {
        self.corners = points
        let path = UIBezierPath()
        
        print(points)
        path.moveToPoint(points.first!)
        
        for i in 1 ..< points.count {
            path.addLineToPoint(points[i])
        }
        path.addLineToPoint(points.first!)
        borderLayer?.path = path.CGPath
    }
    
    func setMyView() {
        borderLayer = CAShapeLayer()
        borderLayer?.strokeColor = UIColor.redColor().CGColor
        borderLayer?.lineWidth = 2.0
        borderLayer?.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(borderLayer!)
    }
    
}