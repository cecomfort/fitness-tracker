//
//  emptyMessageCell.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/26/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

class emptyMessageCell: UITableViewCell {

    @IBOutlet weak var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        message.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
