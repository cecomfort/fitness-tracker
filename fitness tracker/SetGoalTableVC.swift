//
//  SetGoalTableVCTableViewController.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

// LINK UP WORDS (DAY, PRACTICES!!!!!!!), message
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
        
        // modify background image
        let imageView = UIImageView(frame: self.view.frame)
        let image = #imageLiteral(resourceName: "temple")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        cell.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
    @IBAction func saveGoal(_ sender: Any) {
        if let newGoal = Goal(startDate: Date(), endDate: endDatePicker.date, mileGoal: milesGoal, practiceGoal: practiceGoal) {
            print(endDatePicker.date)
            print(milesGoal)
            print(practiceGoal)
            if store.saveGoal(item: newGoal) {
                // segue to goal page
                print("Set and saved")
                performSegue(withIdentifier: "goBacktoGoalProgress", sender: self)
            } else {
                createAlert(title: "Unable to Save Goal", message: "An error occurred. Please try again at a later time.")
            }
        } else {
            createAlert(title: "Unable to Save Goal", message: "End date must be a future date.")
        }
        
    }
    
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
}
