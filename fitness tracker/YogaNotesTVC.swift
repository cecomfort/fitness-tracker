//
//  PracticeDetailsTVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/20/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

// TODO: Enable Done button on text field
// TODO: Selected cells are highlighted :(
// dynamic loading and clearing of cells?
// disenable fields and save btn if loading practice

class YogaNotesTVC: UITableViewController {
    
    @IBOutlet weak var cardioLevel: RatingControl!
    @IBOutlet weak var strengthBuildingLevel: RatingControl!
    @IBOutlet weak var flexibilityLevel: RatingControl!
    @IBOutlet weak var notesTextField: UITextView!
    var yogaPractice : YogaPractice?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // modify background image
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage(named: "mandala")!
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        loadYogaPracticeData()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    
    // change section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.6)
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
            return "Ratings"
        } else {
            return "Notes"
        }
    }
    
//    @IBOutlet weak var cardioLevel: RatingControl!
//    @IBOutlet weak var strengthBuildingLevel: RatingControl!
//    @IBOutlet weak var flexibilityLevel: RatingControl!
//    @IBOutlet weak var notesTextField: UITextView!
    
    private func loadYogaPracticeData() {
        if let savedPractice = yogaPractice {
            cardioLevel.rating = savedPractice.cardioLevel!
            strengthBuildingLevel.rating = savedPractice.strengthBuildingLevel!
            flexibilityLevel.rating = savedPractice.flexibilityLevel!
            notesTextField.text = savedPractice.notes
        }
    }
}
