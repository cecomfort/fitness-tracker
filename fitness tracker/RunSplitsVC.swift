//
//  RunSplitsVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/21/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class RunSplitsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var splits : [Double] = [42.2, 3.3, 4.4, 3.4]
    
    @IBOutlet weak var splitsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splitsTableView.delegate = self
        splitsTableView.dataSource = self
        splitsTableView.register(UINib(nibName: "WorkoutInfoCell", bundle: nil), forCellReuseIdentifier: "WorkoutInfoCell")
        configureTableView()
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutInfoCell", for: indexPath) as! WorkoutInfoCell
        let descriptionLabels = generateDescriptionLabels()
        let valueLabels = splits
        
        
        cell.descriptionLabel.text = descriptionLabels[indexPath.row]
        cell.valueLabel.text = Run.paceToString(pace: valueLabels[indexPath.row])
        
        return cell
        
    }
    
    func generateDescriptionLabels() -> [String] {
        var miles : [String] = []
        for i in 1...splits.count {
            miles.append("Mile \(i)")
        }
        return miles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splits.count
    }
    
    func configureTableView() {
        splitsTableView.rowHeight = 70
        splitsTableView.tableFooterView = UIView()
        //        UITableViewAutomaticDimension
        //        summaryTableView.estimatedRowHeight = 70 // pixels
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Splits"
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
