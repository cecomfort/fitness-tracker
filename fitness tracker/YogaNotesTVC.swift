//
//  PracticeDetailsTVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/20/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class YogaNotesTVC: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var cardioLevel: RatingControl!
    @IBOutlet weak var strengthBuildingLevel: RatingControl!
    @IBOutlet weak var flexibilityLevel: RatingControl!
    @IBOutlet weak var notesTextField: UITextView!
    var yogaPractice : YogaPractice?
    var notesPageVisited = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notesTextField.delegate = self
        notesTextField.returnKeyType = .done
        
        notesPageVisited = true

        // modify background image
        let imageView = UIImageView(frame: self.view.frame)
        let image = UIImage(named: "yoga3")!
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)

        
        loadYogaPracticeData()
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium);
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
    
    private func loadYogaPracticeData() {
        if let savedPractice = yogaPractice {
            cardioLevel.rating = savedPractice.cardioLevel!
            strengthBuildingLevel.rating = savedPractice.strengthBuildingLevel!
            flexibilityLevel.rating = savedPractice.flexibilityLevel!
            notesTextField.text = savedPractice.notes
        }
    }
    
    func resetFields() {
        notesTextField.text = ""
        cardioLevel.rating = 0
        strengthBuildingLevel.rating = 0
        flexibilityLevel.rating = 0
    }
}
