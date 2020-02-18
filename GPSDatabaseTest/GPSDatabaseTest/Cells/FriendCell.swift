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
    @IBAction func SaveFriend(_ sender: Any) {
        storeUIDLocally()
    }
    var UID: String!
    
    var UIDArray: [String] {
        get {
            return UserDefaults.standard.array(forKey: SAVED_FRIENDS_UIDS) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_FRIENDS_UIDS)
        }
    }
    
    func storeUIDLocally(){
        if let uid = UID{
            if !UIDArray.contains(uid){
                UIDArray.append(uid)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
