//
//  WorkoutInfoCell.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/20/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class WorkoutInfoCell: UITableViewCell {

    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
