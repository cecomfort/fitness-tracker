//
//  RunSplitsVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/21/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// Future work: Generate label headers just once

// size of headers? background of headers
// change nav bar title. Run Summary vs. Run Route
// change name of VCs


class RunSplitsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var splits : [Double] = [42.2, 3.3, 4.4, 3.4, 5.5, 4.5, 4.5, 3.4, 4.6]
    var run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [], splitTimes: [])
    var splitCount : Int = 0
    var descriptionLabels: [[String]] = []
    var valueLabels: [[String]] = []
    
    
    @IBOutlet weak var splitsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateLabelData()

        splitsTableView.delegate = self
        splitsTableView.dataSource = self
        
        
        splitsTableView.register(UINib(nibName: "WorkoutInfoCell", bundle: nil), forCellReuseIdentifier: "WorkoutInfoCell")
        configureTableView()
        
        let backgroundImage = UIImage(named: "run11")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        splitsTableView.backgroundView = imageView
        splitsTableView.tableFooterView = UIView()
    }
    
    func generateLabelData() {
        // description labels
        descriptionLabels.append(["Date", "Mileage", "Duration", "Pace"])
        descriptionLabels.append(generateSplitDescriptionLabels())
        
        // value labels
        valueLabels.append(determineDetailCellValues())
        valueLabels.append(generateSplitValueLabels())
        
    }
    
    
    func determineDetailCellValues() -> [String] {
        if let newRun = run {
            let date = DateFormatter.localizedString(from: newRun.date, dateStyle: .medium, timeStyle: .short)
            let mileage = String(format: "%.2f", newRun.mileage) + " mi"
            let pace = Run.paceToString(pace: newRun.avgPace())
            let duration = Stopwatch(time: newRun.duration).convertTimeToString()
            return [date, mileage, duration, pace]
        } else {
            return ["","","",""]
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutInfoCell", for: indexPath) as! WorkoutInfoCell
 
        cell.descriptionLabel.text = descriptionLabels[indexPath.section][indexPath.row]
        cell.valueLabel.text = valueLabels[indexPath.section][indexPath.row]

        cell.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
        return cell
        
    }
    
    func generateSplitValueLabels() -> [String] {
        var splitLabels : [String] = []
        if let splits = run?.splits() {
            for split in splits {
                splitLabels.append(Run.paceToString(pace: split))
            }
        }
        print(splitLabels)
        return splitLabels
    }
    
    func generateSplitDescriptionLabels() -> [String] {
        var miles : [String] = []
        for i in 1...splitCount {
            miles.append("Mile \(i)")
        }
        return miles
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return splitCount
        }
    }
    
    func configureTableView() {
        splitsTableView.rowHeight = 70
        splitsTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if splitCount > 1 {
            return 2
        } else { // If only ran a mile, dont show splits
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Run Details"
        } else {
            return "Splits"
        }
    }
}
