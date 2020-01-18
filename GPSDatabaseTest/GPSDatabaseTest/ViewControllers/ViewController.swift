//
//  ViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 12/11/2019.
//  Copyright © 2019 Artturi Jalli. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    struct Location {
        var latitude = 0.0
        var longitude = 0.0
    }
    
    var myCurrentLocation: Location = Location(latitude: 0.0, longitude: 0.0)
    let messageVisibilityRadius = 100.0
    var detectedMessageIds: [String] = []
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    @IBOutlet weak var MessageField: UITextView!

    @IBOutlet weak var tableView: UITableView!
    var allNearbyMessages: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allNearbyMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        cell.message.text = allNearbyMessages[indexPath.row]
        cell.message.isUserInteractionEnabled = false
        return cell
    }
    
    func addMessagesToTableView(messages: [String]){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: messages.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        let message = self.MessageField.text!
        sendToDatabase(message)
        self.MessageField.text = ""
    }
        
    func sendToDatabase(_ message: String){
        if !message.isEmpty {
            let ref = Database.database().reference()
            let lat = self.locationManager.location?.coordinate.latitude as Any
            let long = self.locationManager.location?.coordinate.longitude as Any
            let time = self.getCurrentTime()
            let data = ["latitude":lat, "longitude":long, "time":time, "message":message]
            ref.child("messages").childByAutoId().setValue(data)
        }
    }
    
    func getCurrentTime() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: Date())
    }
    
    func updateDeviceCurrentLocation() {
        if let loc = locationManager.location{
            myCurrentLocation.latitude = loc.coordinate.latitude
            myCurrentLocation.longitude = loc.coordinate.longitude
        }
    }
    
    //Naive implementation - this gets all the messages from the DB and filters out that aren't close enough to be shown.
    func fetchAndShowMessagesFromDB() {
        let database_reference = Database.database().reference()
        let messagesRef = database_reference.child("messages")
        messagesRef.observe(.childAdded) { (message_data) in
            DispatchQueue.main.async {
                if !(self.detectedMessageIds.contains(message_data.key)){
                    self.updateDeviceCurrentLocation()
                    let deviceLocation = CLLocation(latitude: self.myCurrentLocation.latitude, longitude: self.myCurrentLocation.longitude)
                    let messageLocation = CLLocation(latitude: message_data.childSnapshot(forPath: "latitude").value! as! CLLocationDegrees, longitude: message_data.childSnapshot(forPath: "longitude").value! as! CLLocationDegrees)
                    if distance(loc1: deviceLocation, loc2: messageLocation) < self.messageVisibilityRadius {
                        let message = (message_data.childSnapshot(forPath: "message").value! as! String)
                        self.allNearbyMessages.append(message)
                        self.detectedMessageIds.append(message_data.key)
                        self.addMessagesToTableView(messages: self.allNearbyMessages)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view here.
        startUpdatingLocation()
        fetchAndShowMessagesFromDB()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func startUpdatingLocation() { 
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}
