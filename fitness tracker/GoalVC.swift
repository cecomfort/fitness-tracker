//
//  GoalVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// Future: show hours left when under 24 hrs, more fun bar fills


// show something if no goal
// message if goal not met & freeze workout updates  (check)

class GoalVC: UIViewController {
    
    var store = DataStore.sharedInstance

    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mileCountLabel: UILabel!
    @IBOutlet weak var practiceCountLabel: UILabel!
    @IBOutlet weak var goalProgressBar: CircleProgressBar!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var practicesLabel: UILabel!
    @IBOutlet weak var workoutBreakdownWithLegend: UIView!
    
    @IBOutlet weak var workoutBreakdownBar: WorkoutBreakdownBar!
    @IBOutlet weak var messageLabel: UITextView!
    
    @IBOutlet weak var welcomeImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
        isGoalMet()
        updateMessage()
        
        messageLabel.isEditable = false
        
        workoutBreakdownBar.backgroundColor = .clear
        goalProgressBar.backgroundColor = .clear
        
//        setGoalMessage.isHidden = true
    }
    
    private func updateDisplay() {
        if let goal = store.goal {
            goalProgressBar.isHidden = false
            workoutBreakdownWithLegend.isHidden = false
            welcomeImage.isHidden = true
//            title = "Goal Progress"
            
            // Only update goal status if it is not yet achieved and if the end date hasn't passed
            if !goal.achieved, (goal.endDate > Date() || Calendar.current.isDateInToday(goal.endDate)) {
                print("In updating")
                let daysLeft = goal.daysLeft()
                print("days: \(daysLeft)")
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
        } else {
            // No goal set
            goalProgressBar.isHidden = true
            workoutBreakdownWithLegend.isHidden = true
            welcomeImage.isHidden = false

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
    
    func updateMessage() {
        if let goal = store.goal {
            if goal.achieved {
                messageLabel.text = "Congratulations! You met your goal. 🎉"
            } else if Date() > goal.endDate, !Calendar.current.isDateInToday(goal.endDate) {
                messageLabel.text = "Your goal end date has passed. Set a new goal and try again."
            } else { // goal in progress
                messageLabel.text = ""
            }
        } else {
            messageLabel.text = "Welcome! Set a goal and begin tracking your yoga practices and runs to see your progress."
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
        isGoalMet()
        updateMessage()
    }

}
