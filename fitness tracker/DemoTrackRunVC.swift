//
//  TrackRunVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/15/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import CoreLocation


class DemoTrackRunVC: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    // Timer
    var timer = Timer()
    let stopwatch = Stopwatch()
    
    // Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var startStopLabel: UIButton!
    @IBOutlet weak var finishLabel: UIButton!
    


    //MARK: Additional View setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        startStopLabel.setTitle("Start", for: .normal)
        timerLabel.text = "0:00"
        finishLabel.isHidden = true
        
        
    }
    

    
    // need?
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    // MARK: Timer
    // rename function since starts run as well??
    @IBAction func startStopTimer(_ sender: Any) {
        if startStopLabel.currentTitle == "Start" {
            
            
           
            
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DemoTrackRunVC.updateTimerLabel), userInfo: nil, repeats: true)
            startStopLabel.setTitle("Pause", for: .normal)
            finishLabel.isHidden = true
        } else if startStopLabel.currentTitle == "Pause" {
            timer.invalidate()
            startStopLabel.setTitle("Start", for: .normal)
            finishLabel.isHidden = false
        }
    }
    
    func updateTimerLabel() {
        stopwatch.incrementTime()
        timerLabel.text = stopwatch.convertTimeToString()
    }

    
    @IBAction func finishRun(_ sender: Any) {
        stopwatch.reset()
        timerLabel.text = stopwatch.convertTimeToString()
        finishLabel.isHidden = true
        
     
        performSegue(withIdentifier: "showRunSummary", sender: self)
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
