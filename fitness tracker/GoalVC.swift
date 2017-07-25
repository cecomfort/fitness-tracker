//
//  GoalVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// reset values every time controller loads!
// show hours left when under 24 hrs?
// better to have store instead of goal?
// show something if no goal

class GoalVC: UIViewController {
    
    var store = DataStore.sharedInstance

    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mileCountLabel: UILabel!
    @IBOutlet weak var practiceCountLabel: UILabel!
    @IBOutlet weak var workoutBreakdownLabel: UILabel!
    
    
    
    // WILL CRASH IF THERES NO GOAL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()     
    }
    
    private func updateDisplay() {
        if let goal = store.goal {
            dayCountLabel.text = "\(goal.daysLeft()) day(s) to go"
            practiceCountLabel.text = "\(goal.practicesLeft()) practice(s) to go"
            mileCountLabel.text = String(format: "%.2f", goal.milesLeft()) + " mile(s) to go"
            workoutBreakdownLabel.text = "\(goal.workoutBreakdown())"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
