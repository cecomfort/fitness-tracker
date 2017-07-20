//
//  LogPracticeTVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/11/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import os.log

class LogPracticeTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    var store = DataStore.sharedInstance
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let durationData = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], [":"], ["00", "15", "30", "45"]]
    
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var style: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var instructor: UITextField!
    @IBOutlet weak var focus: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var cardioLevel: RatingControl!
    @IBOutlet weak var strengthBuildingLevel: RatingControl!
    @IBOutlet weak var flexibilityLevel: RatingControl!

    @IBAction func save(_ sender: Any) {
        if let newPractice = YogaPractice(date: datePicker.date, style: style.text!, duration: duration.text!, instructor: instructor.text!, focus: focus.text!, notes: notes.text!, cardioLevel: cardioLevel.rating, strengthBuildingLevel: strengthBuildingLevel.rating, flexibilityLevel: flexibilityLevel.rating) {
            print("cardio: \(cardioLevel.rating)")
            print("strength: \(strengthBuildingLevel.rating)")
            print("flex: \(flexibilityLevel.rating)")
            store.addPractice(item: newPractice)
            clearTextFields()
        }
    }
    
    // MARK: PickerView Methods to select class duration
    func createPickerView() {
        pickerView.delegate = self
        duration.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickingDuration))
        toolbar.setItems([doneButton], animated: true)
        duration.inputAccessoryView = toolbar
    }
    
    func donePickingDuration() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return durationData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationData[component][row]
    }
    
    // Update textfield
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hours = durationData[0][pickerView.selectedRow(inComponent: 0)]
        let minutes = durationData[2][pickerView.selectedRow(inComponent: 2)]
        duration.text = hours + ":" + minutes
    }
    
    
    // MARK: Date Picker Methods to select date & time
    func createDatePicker() {
        // set date picker format
//        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickingDate))
        toolbar.setItems([doneButton], animated: true)
        date.inputAccessoryView = toolbar
        date.inputView = datePicker // linking date text field to date picker
    }
    
    func donePickingDate() {
        date.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .medium, timeStyle: .short)
        self.view.endEditing(true)
    }

    // better way to do this? -> loop?
    func clearTextFields() {
        date.text = ""
        style.text = ""
        duration.text = ""
        location.text = ""
        instructor.text = ""
        focus.text = ""
        notes.text = ""
        cardioLevel.rating = 0
        strengthBuildingLevel.rating = 0
        flexibilityLevel.rating = 0
    }
    

    
//    @IBAction func addPractice(_ sender: Any) {
//        print(date.text!)
//        print(style.text!)
//        print(duration.text!)
//    }
//    @IBAction func save(_ sender: UIBarButtonItem) {
//        print(date.text!)
//        print(style.text!)
//        print(duration.text!)
//
////        if date.text != "" && style.text != "" && duration.text != "" {
////            let newPractice = YogaPractice(date: date.text!, style: style.text!, duration: duration.text!)
////            store.addPractice(item: newPractice)
////        }
//        
//        if let newPractice = YogaPractice(date: date.text!, style: style.text!, duration: duration.text!) {
//            store.addPractice(item: newPractice)
//        }
//    }
    
//    @IBAction func addPractice(_ sender: Any) {

//        if date.text != "" && style.text != "" && duration.text != "" {
//            let newPractice = YogaPractice(date: date.text!, style: style.text!, duration: duration.text!)
//            store.addPractice(item: newPractice)
//        }
        
//        if let newPractice = YogaPractice(date: "07.17.7", style: style.text!, duration: "1 hr") {
//            store.addPractice(item: newPractice)
//        }
//        let newPractice = YogaPractice(date: date.text!, style: style.text!, duration: Double(duration.text!)!, time: timeOfDay.text!, instructor: instructor.text!, focus: focus.text!, notes: notes.text!, cardioLevel: 4, strengthBuildingLevel: 4, stretchingLevel: 4)
//        
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newPractice, toFile: YogaPractice.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Practice successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save practice...", log: OSLog.default, type: .error)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        createPickerView()
        
        style.isUserInteractionEnabled = false
        
        
        // modify background image
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage(named: "mandala")!
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        
//        tableView.backgroundColor = UIColor.clear
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // enable done button in keyboard
        self.style.delegate = self
        self.location.delegate = self
        self.instructor.delegate = self
        self.focus.delegate = self
        self.notes.delegate = self // TODO Needed?? Done button not working!
    }
    
    // Enable done button functionality
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    
    // change section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.6)
//        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
//        headerLabel.font = UIFont(name: "Verdana", size: 20)
        headerLabel.textColor = UIColor.black
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Class Details"
        } else if section == 1 {
            return "Ratings"
        } else {
            return "Notes"
        }
    }
  

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }


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
