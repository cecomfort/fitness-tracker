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
        return store.yogaPractices.count
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkoutCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutCell
            else {
                fatalError("The dequeued cell is not an instance of a WorkoutCell.")
        }
        let practice = store.yogaPractices[indexPath.row]
        print(practice.date)
        print(practice.style)
        print(practice.duration)
        
        cell.dateLabel.text = practice.date
        cell.typeLabel.text = practice.style
        cell.durationLabel.text = practice.duration

        return cell
     }
    
    // MARK: Delete Workout
 
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
