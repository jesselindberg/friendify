//
//  FriendViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 18/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit
import Foundation

import FirebaseDatabase
import FirebaseAuth
import FirebaseUI
import FirebaseStorage

import CoreLocation

class FriendViewController: FriendifyController, UITableViewDelegate, UITableViewDataSource {
    
    var myLocation: [String: Any] = [:]
    
    var shownUserIDS:[String] = []
    func fetchAndShowUsersFromDB() {
        let database_reference = Database.database().reference()
        let messagesRef = database_reference.child("locations")
        messagesRef.observe(.childAdded) { (location_data) in
            DispatchQueue.main.async {
                let UID = location_data.key
                if !(self.shownUserIDS.contains(UID)){
                    self.updateMyCurrentLocation()
                    let deviceLocation = CLLocation(latitude: self.myCurrentLocation.latitude, longitude: self.myCurrentLocation.longitude)
                    guard let lat = location_data.childSnapshot(forPath: "latitude").value as? CLLocationDegrees else { return }
                    guard let long = location_data.childSnapshot(forPath: "longitude").value as? CLLocationDegrees else { return }
                    let messageLocation = CLLocation(latitude: lat, longitude: long)
                    //if distance(loc1: deviceLocation, loc2: messageLocation) < VISIBILITY_RADIUS {
                        self.shownUserIDS.append(UID)
                        self.tableView.reloadData()
                    //}
                }
            }
        }
    }
    
    func getDeviceCurrentLocation() -> CLLocation{
        let location = CLLocation()
        return location
    }
    
    func currentTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM HH:mm"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func updateDeviceLocationToDB(){
        let ref = Database.database().reference()
        ref.child("locations/\(myUserID)").setValue(myLocation)
    }
    
    func updateLocationToDB(with_interval: Double){
        getCurrentLocation()
        Timer.scheduledTimer(withTimeInterval: with_interval, repeats: true) { timer in
            self.myLocation["latitude"] = self.locationManager.location?.coordinate.latitude as Any
            self.myLocation["longitude"] = self.locationManager.location?.coordinate.longitude as Any
            self.myLocation["timestamp"] = self.currentTime()
            self.updateDeviceLocationToDB()
            print("Updated location")
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shownUserIDS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createFriendCell(tableView, cellForRowAt: indexPath, withUID: shownUserIDS[indexPath.row])
    }
    
    func createFriendCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withUID: String) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.InfoField.text = ""
        cell.PictureField?.image = UIImage(named: "empty_profile.png")

        let storageRef = Storage.storage().reference()
        let pictureReference = storageRef.child("profile/\(withUID)")
        pictureReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            DispatchQueue.main.async{
                cell.PictureField.image = UIImage(data: data!)!
                self.fetchUserInfo(withUID: withUID, completionHandler: { info in
                    cell.InfoField.text = info
                    cell.UID = withUID
                })
            }
          }
        }
        return cell
    }
    
    func fetchUserInfo(withUID: String, completionHandler:@escaping (_ info: String) -> ()) {
        Database.database().reference().child("users/\(withUID)").observeSingleEvent(of: .value) { snapshot in
            let userInfo = snapshot.value as? [String : AnyObject] ?? [:]
            if let information = userInfo["username"]{
                completionHandler(information as! String)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchAndShowUsersFromDB()
        updateLocationToDB(with_interval: 5.0)
        handleSwipe()
        handleKeyboardShowing()
    }
    
    func handleSwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }
}

extension UIViewController{
    @objc func swipeAction(swipe: UISwipeGestureRecognizer){
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "ChatToFriend", sender: self)
        case 2:
            performSegue(withIdentifier: "FriendToChat", sender: self)
        default:
            break
        }
    }
}


