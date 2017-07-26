//
//  SetGoalTableVCTableViewController.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class SetGoalTableVC: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    let milesPickerData = Array(1...100)
    let practicePickerData = Array(1...35)
    var milesGoal = 1
    var practiceGoal = 1
    var store = DataStore.sharedInstance
    
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var milesPicker: UIPickerView!
    @IBOutlet weak var practicePicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        formatDatePicker()
        milesPicker.delegate = self
        practicePicker.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func saveGoal(_ sender: Any) {
        if let newGoal = Goal(startDate: Date(), endDate: endDatePicker.date, mileGoal: milesGoal, practiceGoal: practiceGoal) {
            if store.saveGoal(item: newGoal) {
                // segue to goal page
                print("Set and saved")
            } else {
                createAlert(title: "Unable to Save Goal", message: "An error occurred. Please try again at a later time.")
            }
        } else {
            createAlert(title: "Unable to Save Goal", message: "End date must be a future date.")
        }
    }
    
//    @IBAction func saveGoal(_ sender:
//        Any) {
//
//        if let newGoal = Goal(startDate: Date(), endDate: endDatePicker.date, mileGoal: milesGoal, practiceGoal: practiceGoal) {
//            if store.saveGoal(item: newGoal) {
//                // segue to goal page
//                print("Set and saved")
//            } else {
//                createAlert(title: "Unable to Save Goal", message: "An error occurred. Please try again at a later time.")
//            }
//        } else {
//            createAlert(title: "Unable to Save Goal", message: "End date must be a future date.")
//        }
//    }
    
    // MARK: Alert Method
    func createAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Date Picker Methods
    func formatDatePicker() {
        endDatePicker.datePickerMode = .date
    }
    
    // MARK: Picker Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == milesPicker {
            return milesPickerData.count
        } else { // pickerView == practicePicker
            return practicePickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == milesPicker {
            return String(milesPickerData[row])
        } else { // pickerView == practicePicker
            return String(practicePickerData[row])
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == milesPicker {
            milesGoal = milesPickerData[row]
        }
        if pickerView == practicePicker {
            practiceGoal = practicePickerData[row]
        }
    }
    
    
    
 // MARK: - Table view data sourcedfds

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
