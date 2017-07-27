//
//  LogPracticeTVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/11/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class YogaDetailsTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    var yogaPractice : YogaPractice?
    let datePicker = UIDatePicker() 
    let pickerView = UIPickerView()
    let durationData = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], [":"], ["00", "15", "30", "45"]]
    
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var style: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var instructor: UITextField!
    @IBOutlet weak var focus: UITextField!
    
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
        
//        style.isUserInteractionEnabled = false
        
        
        // modify background image
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage(named: "yoga3")!
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
        
        loadYogaPracticeData()
    }

    private func loadYogaPracticeData() {
        if let savedPractice = yogaPractice {
            date.text = DateFormatter.localizedString(from: savedPractice.date, dateStyle: .medium, timeStyle: .short)
            style.text = savedPractice.style
            duration.text = savedPractice.duration
            location.text = savedPractice.location
            instructor.text = savedPractice.instructor
            focus.text = savedPractice.focus
        }
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


    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.25)
    }
    
    // change section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.6)
//        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium);
        headerLabel.textColor = UIColor.black
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Class Details"
    }
  
    
    func resetFeilds() {
        style.text = ""
        date.text = ""
        duration.text = ""
        location.text = ""
        instructor.text = ""
        focus.text = ""
    }

}
