//
//  GoalVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// show hours left when under 24 hrs?
// better to have store instead of goal?
// show something if no goal
// More fun stroke fills?
// message if goal not met & freeze workout updates  (check)

class GoalVC: UIViewController {
    
    var store = DataStore.sharedInstance

    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mileCountLabel: UILabel!
    @IBOutlet weak var practiceCountLabel: UILabel!
    @IBOutlet weak var goalProgressBar: CircleProgressBar!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var practicesLabel: UILabel!
    
    @IBOutlet weak var workoutBreakdownBar: WorkoutBreakdownBar!
    
    
    // WILL CRASH IF THERES NO GOAL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
        
        isGoalMet()
        
        workoutBreakdownBar.backgroundColor = .clear
        goalProgressBar.backgroundColor = .clear
        
//        setGoalMessage.isHidden = true
    }
    
    private func updateDisplay() {
        if let goal = store.goal {
            if !goal.achieved { //, goal.endDate < Date()
                
                let daysLeft = goal.daysLeft()
                if daysLeft == 1 {
                    daysLabel.text = "day"
                } else {
                    daysLabel.text = "days"
                }

                
                let practicesLeft = goal.practicesLeft()
                if practicesLeft == 1 {
                    practicesLabel.text = "practice"
                } else {
                    practicesLabel.text = "practices"
                }
                
                dayCountLabel.text = "\(daysLeft)"
                practiceCountLabel.text = "\(goal.practicesLeft())"
                
                let milesLeft = goal.milesLeft()
                if milesLeft <= 0 {
                    mileCountLabel.text = "0"
                } else {
                    mileCountLabel.text = String(format: "%.2f", goal.milesLeft())
                }
//                mileCountLabel.text = String(format: "%.2f", goal.milesLeft())
           
                goalProgressBar.percentPracticesComplete = CGFloat(goal.percentPracticesComplete())
                goalProgressBar.percentMilesComplete = CGFloat(goal.percentMilesComplete())
                goalProgressBar.setNeedsDisplay()
            
                workoutBreakdownBar.workoutBreakdown = goal.workoutBreakdown()
                workoutBreakdownBar.setNeedsDisplay()
            }
        }
    }
    
    func isGoalMet() {
        if let goal = store.goal {
            if goal.practicesLeft() == 0, goal.milesLeft() == 0 {
                goal.achieved = true
                print("wahoo! Goal met!")
            }
        }
    }
    
    @IBAction func unwindToGoalVC(_ segue: UIStoryboardSegue) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDisplay()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
