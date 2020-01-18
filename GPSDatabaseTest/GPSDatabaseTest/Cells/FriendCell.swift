//
//  FriendCell.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 18/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var PictureField: UIImageView!
    @IBOutlet weak var InfoField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
