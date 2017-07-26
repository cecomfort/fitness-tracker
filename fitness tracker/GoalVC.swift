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

class GoalVC: UIViewController {
    
    var store = DataStore.sharedInstance

    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mileCountLabel: UILabel!
    @IBOutlet weak var practiceCountLabel: UILabel!
    @IBOutlet weak var workoutBreakdownLabel: UILabel!
    @IBOutlet weak var goalProgressBar: CircleProgressBar!
    
    @IBOutlet weak var workoutBreakdownBar: WorkoutBreakdownBar!
    
    
    // WILL CRASH IF THERES NO GOAL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
        
        isGoalMet()
        
//        setGoalMessage.isHidden = true
    }
    
    private func updateDisplay() {
        if let goal = store.goal {
            if !goal.achieved {
                dayCountLabel.text = "\(goal.daysLeft()) days"
                practiceCountLabel.text = "\(goal.practicesLeft()) practices"
                mileCountLabel.text = String(format: "%.2f", goal.milesLeft()) + " miles"
                workoutBreakdownLabel.text = "\(goal.workoutBreakdown())"
           
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
