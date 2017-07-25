//
//  GoalVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class GoalVC: UIViewController {
    
    var store = DataStore.sharedInstance

    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mileCountLabel: UILabel!
    @IBOutlet weak var practiceCountLabel: UILabel!
    @IBOutlet weak var workoutBreakdownLabel: UILabel!
    
    
    
    // WILL CRASH IF THERES NO GOAL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let days = store.goal?.daysLeft() {
            dayCountLabel.text = "\(days) days to go"
        }


        // Do any additional setup after loading the view.
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
