//
//  FriendViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 18/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit
import Foundation

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var friendCells: [FriendCell] = []
    
    let exampleData: [[String:String]] = [["info":"Matti Meikäläinen, 23v, Aalto-Yliopisto, Tekniikan kandidaatti", "picture": "empty_profile.png"],
                       ["info":"Kalle Kalamies, 26v, Aalto-Yliopisto, Diplomi-insinööri", "picture": "empty_profile.png"],
                       ["info":"Petteri Peloton, 19v, Aalto-Yliopisto, Tekniikan ylioppilas", "picture" : "empty_profile.png"]]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.InfoField.text = friendCells[indexPath.row].InfoField.text
        cell.PictureField.image = friendCells[indexPath.row].PictureField.image
        return cell
    }
    
    func createFriendCellFrom(data: [String:String]) -> FriendCell {
        let info = data["info"]
        let imageName = data["picture"]!
        let image = UIImage(named: imageName)
        let friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendCell
        friendCell.InfoField.text = info!
        friendCell.imageView?.image = image
        return friendCell
    }
    
    func transformDataToFriendCellArray(data: [[String:String]]) -> [FriendCell] {
        var friendCells: [FriendCell] = []
        for data in exampleData{
            let friendCell = createFriendCellFrom(data: data)
            friendCells.append(friendCell)
        }
        return friendCells
    }
    
    func addFriendsToFriendView(friends: [FriendCell]) {
        print(friends.count)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: friends.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        friendCells = transformDataToFriendCellArray(data: exampleData)
        addFriendsToFriendView(friends: friendCells)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
