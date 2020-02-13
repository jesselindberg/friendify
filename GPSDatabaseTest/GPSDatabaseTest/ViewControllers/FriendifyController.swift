//
//  FriendifyController.swift
//  
//
//  Created by Artturi Jalli on 13/02/2020.
//

import UIKit
import Foundation

import FirebaseDatabase
import FirebaseAuth
import FirebaseUI
import FirebaseStorage

import CoreLocation

class FriendifyController: UIViewController, CLLocationManagerDelegate, FUIAuthDelegate {
    let locationManager = CLLocationManager()
    let myUserID = Auth.auth().currentUser!.uid
    
    struct Location {
        var latitude = 0.0
        var longitude = 0.0
    }
    
    var myCurrentLocation: Location = Location()

    func getCurrentTime() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: Date())
    }
    
    func getCurrentLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateMyCurrentLocation() {
        if let loc = locationManager.location{
            myCurrentLocation.latitude = loc.coordinate.latitude
            myCurrentLocation.longitude = loc.coordinate.longitude
        }
    }
    
    func startUpdatingMyLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func handleKeyboardShowing(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
