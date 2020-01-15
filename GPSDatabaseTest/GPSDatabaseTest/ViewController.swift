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
    var detectedMessageIds: [String] = []
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
        if let loc = locationManager.location{
            let lat = self.locationManager.location?.coordinate.latitude
            let long = self.locationManager.location?.coordinate.longitude
            return (lat!, long!)
        }else{
            return (0,0)
        }
    }
    
    func showMessagesFromDB(){
        let database_reference = Database.database().reference()
        let productRef = database_reference.child("messages")
        productRef.observe(.childAdded) { (message_data) in
            DispatchQueue.main.async {
                if !(self.detectedMessageIds.contains(message_data.key)){
                    let lat = self.getDeviceCurrentLocation().0
                    let long = self.getDeviceCurrentLocation().1
                    let deviceLocation = CLLocation(latitude: lat, longitude: long)
                    let messageLocation = CLLocation(latitude: message_data.childSnapshot(forPath: "latitude").value! as! CLLocationDegrees, longitude: message_data.childSnapshot(forPath: "longitude").value! as! CLLocationDegrees)
                    if distance(loc1: deviceLocation, loc2: messageLocation) < 100{
                        self.addNewMessageBox(withMessage: (message_data.childSnapshot(forPath: "message").value! as! String))
                        self.detectedMessageIds.append(message_data.key)
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
        let y = getBottomMessagePosition().y - messageBoxHeight
        return CGPoint(x: x, y: y)
    }
    
    func initBottomMessagePosition(){
        bottomMessagePosition = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height/1.2)
    }
    
    func addNewMessageBox(withMessage: String){
        let label = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: messageBoxHeight))
        label.center = newMessageCenterPosition()
        label.textAlignment = .center
        label.text = withMessage
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        self.view.addSubview(label)
        updateBottom(messagePosition: label.center)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startUpdatingLocation()
        showMessagesFromDB()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
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
    
    func startUpdatingLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

