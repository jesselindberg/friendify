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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let messageBoxHeight = CGFloat(50)
    var detected_message_ids: [String] = []
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var bottomMessagePosition: CGPoint!
    var bottomMessage: UITextView!
    @IBOutlet weak var MessageField: UITextView!
    
    @IBAction func SendMessage(_ sender: Any) {
        let message = self.MessageField.text!
        sendToDatabase(message: message)
        self.MessageField.text = ""
    }
    
    // This does nothing but removing it causes the app crash... Probably caused by some dependency etc...
    @IBAction func UpdateLocation(_ sender: Any) {
    }
        
    func sendToDatabase(message: String){
        if !message.isEmpty{
            let ref = Database.database().reference()
            let lat = self.locationManager.location?.coordinate.latitude as Any
            let long = self.locationManager.location?.coordinate.longitude as Any
            let time = self.getCurrentTime()
            let data = ["latitude":lat, "longitude":long, "time":time, "message":message]
            ref.child("messages").childByAutoId().setValue(data)
        }
    }
    
    func getCurrentTime() -> String{
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: Date())
    }
    
    func getDeviceCurrentLocation() -> (CLLocationDegrees, CLLocationDegrees){
        let lat = self.locationManager.location?.coordinate.latitude
        let long = self.locationManager.location?.coordinate.longitude
        return (lat!, long!)
    }
    
    func showMessagesFromDB(){
        let database_reference = Database.database().reference()
        let productRef = database_reference.child("messages")
        productRef.observe(.childAdded) { (message_data) in
            DispatchQueue.main.async {
                if !(self.detected_message_ids.contains(message_data.key)){
                    let lat = self.getDeviceCurrentLocation().0
                    let long = self.getDeviceCurrentLocation().1
                    let deviceLocation = CLLocation(latitude: lat, longitude: long)
                    let messageLocation = CLLocation(latitude: message_data.childSnapshot(forPath: "latitude").value! as! CLLocationDegrees, longitude: message_data.childSnapshot(forPath: "longitude").value! as! CLLocationDegrees)
                    if distance(loc1: deviceLocation, loc2: messageLocation) < 100{
                        self.addNewMessageBox(withMessage: (message_data.childSnapshot(forPath: "message").value! as! String))
                        self.detected_message_ids.append(message_data.key)
                    }
                }
            }
        }
    }
    
    func updateBottom(messagePosition: CGPoint){
        bottomMessagePosition = messagePosition
    }
    
    func getBottomMessagePosition() -> CGPoint {
        if let pos = bottomMessagePosition{
            return pos
        }else{
            initBottomMessagePosition()
            return bottomMessagePosition
        }
    }
    
    func newMessageCenterPosition() -> CGPoint{
        let x = getBottomMessagePosition().x
        let y = getBottomMessagePosition().y + messageBoxHeight
        return CGPoint(x: x, y: y)
    }
    
    func initBottomMessagePosition(){
       bottomMessagePosition = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height/2)
    }
    
    func addNewMessageBox(withMessage: String){
        let label = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: messageBoxHeight))
        label.center = newMessageCenterPosition()
        label.textAlignment = .center
        label.text = withMessage
        print(label.center)
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.isUserInteractionEnabled = false
        self.view.addSubview(label)
        updateBottom(messagePosition: label.center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startUpdatingLocation()
        showMessagesFromDB()
    }
    
    func startUpdatingLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

