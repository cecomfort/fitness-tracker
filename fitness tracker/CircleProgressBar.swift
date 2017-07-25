//
//  circleProgressBar.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/25/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

//        path.fill(with: <#T##CGBlendMode#>, alpha: <#T##CGFloat#>)
//        path.setLineDash(<#T##pattern: UnsafePointer<CGFloat>?##UnsafePointer<CGFloat>?#>, count: <#T##Int#>, phase: <#T##CGFloat#>)
//        path.getLineDash(<#T##pattern: UnsafeMutablePointer<CGFloat>?##UnsafeMutablePointer<CGFloat>?#>, count: <#T##UnsafeMutablePointer<Int>?#>, phase: <#T##UnsafeMutablePointer<CGFloat>?#>)
//        color.setStroke()

import UIKit

@IBDesignable class CircleProgressBar: UIView {
    
    // 1 percent = pi/50
    // π/50 * percent
    
    @IBInspectable var percentPracticesComplete : CGFloat = 60.0
    @IBInspectable var percentMilesComplete : CGFloat = 40.0
    @IBInspectable var workoutBreakdown = ["cardioPercentage" : 0.0, "strengthBuildingPercentage" : 0.0, "flexibilityPercentage" : 0.0]
    
    
    let π:CGFloat = CGFloat(Double.pi)
    
    //    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var yogaPracticeCompleteColor: UIColor = UIColor.magenta
    @IBInspectable var yogaPracticeIncompleteColor: UIColor = UIColor.gray
    @IBInspectable var ruCompletenColor: UIColor = UIColor.cyan
    @IBInspectable var runIncompleteColor: UIColor = UIColor.darkGray
    
    func drawCircle(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color : UIColor) {
        let center = CGPoint(x:bounds.midX, y: bounds.midY)
        let arcWidth: CGFloat = 20
        let path = UIBezierPath(arcCenter: center, radius: radius - arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.lineWidth = arcWidth
        color.setStroke()
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        
        let diameter = max(bounds.width, bounds.height)
        
        // running
        drawCircle(radius: diameter / 2, startAngle: 0, endAngle: 2 * π, color: runIncompleteColor)
        //        drawCircle(radius: diameter / 2, startAngle: 3 * π / 2, endAngle: π, color: ruCompletenColor)
        drawCircle(radius: diameter / 2, startAngle: 3 * π / 2, endAngle: π/50 * percentMilesComplete, color: ruCompletenColor)
        
        // yoga
        drawCircle(radius: (diameter - 40) / 2, startAngle: 0, endAngle:  2 * π, color: yogaPracticeIncompleteColor)
        //         drawCircle(radius: (diameter - 40) / 2, startAngle: 0, endAngle:  2 * π, color: yogaPracticeCompleteColor)
        drawCircle(radius: (diameter - 40) / 2, startAngle: 3 * π / 2, endAngle: π/50 * percentPracticesComplete, color: yogaPracticeCompleteColor)
        
    }

}
