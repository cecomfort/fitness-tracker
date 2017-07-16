//
//  TrackRunVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/15/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class TrackRunVC: UIViewController {
    
    // MARK: Properties
    // Timer
    var timer = Timer()
    let stopwatch = Stopwatch()
    
    // Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var startStopLabel: UIButton!

    //MARK: Additional View setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startStopLabel.setTitle("Start", for: .normal)
        timerLabel.text = "0:00"
        
    }

    // MARK: Timer
    @IBAction func startStopTimer(_ sender: Any) {
        if startStopLabel.currentTitle == "Start" {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TrackRunVC.updateTimerLabel), userInfo: nil, repeats: true)
            startStopLabel.setTitle("Pause", for: .normal)
        } else if startStopLabel.currentTitle == "Pause" {
            timer.invalidate()
            startStopLabel.setTitle("Start", for: .normal)
        }
    }
    
    func updateTimerLabel() {
        stopwatch.incrementTime()
        timerLabel.text = stopwatch.convertTimeToString()
    }

    
    @IBAction func finishRun(_ sender: Any) {

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
