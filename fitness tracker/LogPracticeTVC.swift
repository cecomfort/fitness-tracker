//
//  LogPracticeTVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/11/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import os.log

class LogPracticeTVC: UITableViewController, UITextFieldDelegate {
    var store = DataStore.sharedInstance
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var style: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var timeOfDay: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var instructor: UITextField!
    @IBOutlet weak var focus: UITextField!
    @IBOutlet weak var notes: UITextView!

    @IBAction func save(_ sender: Any) {
        print(date.text!)
        print(style.text!)
        print(duration.text!)
        
        if let newPractice = YogaPractice(date: date.text!, style: style.text!, duration: duration.text!) {
            print(newPractice.style)
            store.addPractice(item: newPractice)
            clearTextFields()
        }
    }
    
    
    // better way to do this? -> loop?
    func clearTextFields() {
        date.text = ""
        style.text = ""
        duration.text = ""
        timeOfDay.text = ""
        location.text = ""
        instructor.text = ""
        focus.text = ""
        notes.text = ""
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
   
        
//        let newPractice = YogaPractice(date: "08.08.18", style: "Yin", duration: "1 hr")
//        print("before saving")
//        print(newPractice!.style)
//        
//        store.addPractice(item: newPractice!)
//        guard let pratices = NSKeyedUnarchiver.unarchiveObject(withFile:DataStore.filePath) as? [YogaPractice] else { return }
//        print(pratices)
        
        
//        print("DPR: in viewDidLoad")
//        NSKeyedArchiver.archiveRootObject("this is a test", toFile: filePath)
//        
//
//        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? String else { return }
//        print(data)
        
        
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
        self.date.delegate = self
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
        cell.backgroundColor = UIColor.clear
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
