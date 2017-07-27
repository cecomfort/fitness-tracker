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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        print(store.yogaPractices.count)
        configureTableView()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cellBackground = UIImageView(image: #imageLiteral(resourceName: "boards2"))
        cell.backgroundView = UIImageView(image: #imageLiteral(resourceName: "goal2"))
    }
    
    func configureTableView() {
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
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
        if store.workouts.count < 8 {
            return store.workouts.count + 8
        } else {
            return store.workouts.count
        }
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row >= store.workouts.count, let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell", for: indexPath) as? emptyMessageCell {
            if store.workouts.count == 0 && indexPath.row == 1 {
                cell.message.text = "No workouts to show at this time."
            }
            return cell
        } else if let run = store.workouts[indexPath.row] as? Run, let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath) as? RunCell {
            cell.dateLabel.text = DateFormatter.localizedString(from: run.date, dateStyle: .medium, timeStyle: .none)
            cell.typeLabel.text = String(format: "%.2f", run.mileage) + " mi"
            cell.durationLabel.text = Stopwatch(time: run.duration).convertTimeToHourString() + " hr"
            return cell
        } else if let practice = store.workouts[indexPath.row] as? YogaPractice, let cell = tableView.dequeueReusableCell(withIdentifier: "YogaPracticeCell", for: indexPath) as? YogaPracticeCell {
            cell.dateLabel.text = DateFormatter.localizedString(from: practice.date, dateStyle: .medium, timeStyle: .none)
            
            cell.typeLabel.text = practice.style
            cell.durationLabel.text = practice.duration + " hr"
            return cell
        }
        fatalError("The dequeued cell is not an instance of a RunCell or YogaPracticeCell.")
     }
    
    // MARK: Delete Workout
    // swipe to delete table view cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete && store.workouts.count > 0 {
            deleteWorkoutIndexPath = indexPath
            confirmDelete()
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
            store.deleteWorkout(index: indexPath.row) // delete from file
            self.tableView.deleteRows(at: [indexPath], with: .automatic) // delete cell from view
            deleteWorkoutIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    // Cancelation of deletion
    func cancelDeleteWorkout(alertAction: UIAlertAction!) {
        deleteWorkoutIndexPath = nil
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRunDetailsWithSplits" {
            let destinationVC = segue.destination as! RunPageVC
            if let run = store.workouts[selectedIndex] as? Run {
                print("Run selected!")
                destinationVC.run = run
            }
        } else if segue.identifier == "showYogaPracticeDetails" {
            let desinationVC = segue.destination as? YogaPracticePageVC
            if let yogaPractice = store.workouts[selectedIndex] as? YogaPractice {
                print("Yoga practice selected!")
                desinationVC?.yogaPractice = yogaPractice
                desinationVC?.practiceIndex = selectedIndex
            }
        }
    }
}
