//
//  WorkoutLogTVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/13/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class WorkoutLogTVC: UITableViewController {
    
    
    //MARK: Properties
    var store = DataStore.sharedInstance
    var deleteWorkoutIndexPath: IndexPath? = nil
    var selectedIndex = 0
    
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var typeLabel: UILabel!
//    @IBOutlet weak var durationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(store.yogaPractices.count)
//        print(store.yogaPractices)
        
        // Load any saved data
//        if let savedPractices = loadPractices() {
//            practices += savedPractices
//        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //MARK: Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Load added data
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return store.yogaPractices.count + store.runs.count
        return store.workouts.count
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "WorkoutCell"
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutCell
//            else {
//                fatalError("The dequeued cell is not an instance of a WorkoutCell.")
//        }
//        
        // guard -> else continue, guard -> fatal error 
        if let run = store.workouts[indexPath.row] as? Run, let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath) as? RunCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath) as? RunCell
            cell.dateLabel.text = DateFormatter.localizedString(from: run.date, dateStyle: .medium, timeStyle: .short)
            cell.typeLabel.text = String(format: "%.2f", run.mileage) + " mi"
            cell.durationLabel.text = Stopwatch(time: run.duration).convertTimeToString()
            return cell
        } else if let practice = store.workouts[indexPath.row] as? YogaPractice, let cell = tableView.dequeueReusableCell(withIdentifier: "YogaPracticeCell", for: indexPath) as? YogaPracticeCell {
            cell.dateLabel.text = DateFormatter.localizedString(from: practice.date, dateStyle: .medium, timeStyle: .short)
            
            cell.typeLabel.text = practice.style
            cell.durationLabel.text = practice.duration
            return cell
        }
        fatalError("The dequeued cell is not an instance of a RunCell or YogaPracticeCell.")
           
    
//        let cell2 = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? WorkoutCell
//        return cell2!
//
//        if indexPath.row < store.yogaPractices.count {
//            let practice = store.yogaPractices[indexPath.row]
//            cell.dateLabel.text = DateFormatter.localizedString(from: practice.date, dateStyle: .medium, timeStyle: .short)
//
//            cell.typeLabel.text = practice.style
//            cell.durationLabel.text = practice.duration
//        } else { // run workout
//            let run = store.runs[indexPath.row - store.yogaPractices.count]
//            cell.dateLabel.text = DateFormatter.localizedString(from: run.date, dateStyle: .medium, timeStyle: .short)
//            cell.typeLabel.text = String(format: "%.2f", run.mileage) + " mi"
//            cell.durationLabel.text = Stopwatch(time: run.duration).convertTimeToString()
//        }
////        let practice = store.yogaPractices[indexPath.row]
////        print(practice.date)
////        print(practice.style)
////        print(practice.duration)
////        
////        cell.dateLabel.text = practice.date
////        cell.typeLabel.text = practice.style
////        cell.durationLabel.text = practice.duration
//
//        return cell
     }
    
    // MARK: Delete Workout 
    // TODO: Update for deleting workout!!!
 
    // swipe to delete table view cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteWorkoutIndexPath = indexPath
            confirmDelete()
//            store.deletePractice(index: indexPath.row) // delete from file
//            self.tableView.deleteRows(at: [indexPath], with: .automatic) // delete cell from view
            
        }
    }
    
    // Alert asking to confirm delete action
    func confirmDelete() {
        let alert = UIAlertController(title: "Delete Workout", message: "Are you sure you want to permanently delete this workout?", preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteWorkout)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteWorkout)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Actually deletion of workout
    func handleDeleteWorkout(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteWorkoutIndexPath {
            tableView.beginUpdates()
            store.deletePractice(index: indexPath.row) // delete from file
            self.tableView.deleteRows(at: [indexPath], with: .automatic) // delete cell from view
            deleteWorkoutIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    // Cancelation of deletion
    func cancelDeleteWorkout(alertAction: UIAlertAction!) {
        deleteWorkoutIndexPath = nil
    }
    
    
    // MARK: Navigation
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//        
////        if indexPath.row >= store.yogaPractices.count {
////            selectedIndex = indexPath.row
////            performSegue(withIdentifier: "showRunDetails", sender: self)
////        }
//    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRunDetails" {
            let destinationVC = segue.destination as! RunSummaryVC
//            destinationVC.run = store.runs[selectedIndex - store.yogaPractices.count]
            if let run = store.workouts[selectedIndex] as? Run {
                print("Run selected!")
                destinationVC.run = run
            }
//            destinationVC.run = store.workouts[selectedIndex] as? Run
//            store.workouts[indexPath.row] as? Run
        }
    }


    
//    private func loadPractices() -> [YogaPractice]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: YogaPractice.ArchiveURL.path) as? [YogaPractice]
//    }



    // MARK: - Table view data source






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
