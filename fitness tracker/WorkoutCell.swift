//
//  WorkoutCell.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/13/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class YogaPracticeCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
