//
//  workoutBreakdownBar.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/26/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

@IBDesignable class WorkoutBreakdownBar: UIView {
        
    @IBInspectable var workoutBreakdown : [String : Double] = ["cardioPercentage" : 0.51, "strengthBuildingPercentage" : 0.31, "flexibilityPercentage" : 0.18]
        
    @IBInspectable var cardioColor : UIColor = .magenta
    @IBInspectable var strengthBuildingColor : UIColor = .cyan
    @IBInspectable var flexibilityColor : UIColor = .yellow
    @IBInspectable var noWorkoutsColor : UIColor = .lightGray
        
        
    private func drawRect(width: CGFloat, color: UIColor) {
        let path = UIBezierPath()
            
        path.lineWidth = 20.0
            
        // Start of line
        path.move(to: CGPoint(x: 0, y: bounds.height/2))
            
        // End of line
        path.addLine(to: CGPoint(x: width, y:bounds.height/2))
            
        color.setStroke()
        path.stroke()
    }
        
        
    override func draw(_ rect: CGRect) {
        let maxWidth : CGFloat = max(bounds.width, bounds.height)
            
        if let cardioPercentage = workoutBreakdown["cardioPercentage"], let flexPercentage = workoutBreakdown["flexibilityPercentage"], let strengthPercentage =  workoutBreakdown["strengthBuildingPercentage"] {
            
            if cardioPercentage == 0.0, flexPercentage == 0.0, strengthPercentage == 0.0 {
                drawRect(width: maxWidth, color: noWorkoutsColor)
            } else {
                // Flexibility
                drawRect(width: maxWidth, color: flexibilityColor)
                
                // Strength Building
                drawRect(width: maxWidth * CGFloat(1.0 - flexPercentage), color: strengthBuildingColor)
                
                // Cardio
                drawRect(width: maxWidth * CGFloat(cardioPercentage), color: cardioColor)
            }
        }
    }
}
