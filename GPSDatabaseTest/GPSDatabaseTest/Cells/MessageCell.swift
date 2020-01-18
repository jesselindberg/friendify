//
//  MessageCell.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 17/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
