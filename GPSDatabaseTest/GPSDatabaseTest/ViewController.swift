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
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    @IBOutlet weak var LocationsField: UILabel!
    
    var locationsData: Array<[String: Any]> = []
    @IBAction func UpdateLocation(_ sender: Any) {
        updateDeviceLocationToDB()
    }
    
    @IBAction func ShowLocations(_ sender: Any) {
        showDetectedDevices()
    }
    
    func getDeviceCurrentLocation() -> CLLocation{
        let location = CLLocation()
        return location
    }
    
    func updateDeviceLocationToDB(){
        let ref = Database.database().reference()
        ref.child("DeviceData/\(UIDevice.current.name)").setValue(locationsData)
    }
    
    func currentTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func showDetectedDevices(){
        let ref = Database.database().reference()
        let productRef = ref.child("DeviceData")

        productRef.observeSingleEvent(of: .value, with: { snapshot in
            let locationDict: Dictionary<String,Dictionary<String,Any>>  = snapshot.value! as! Dictionary<String,Dictionary<String,Any>>
            let device_names = locationDict.keys
            var names_info = "Devices in the Database: \n"
            for name in device_names{
                names_info.append(name + "\n")
            }
            self.LocationsField.text = names_info
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCurrentLocation()
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
            if self.locationsData.count > 10{
                self.locationsData.removeFirst()
            }
            self.locationsData.append([
                "latitude": self.locationManager.location?.coordinate.latitude as Any,
                "longitude": self.locationManager.location?.coordinate.longitude as Any,
                "timestamp": self.currentTime()
            ])
        }
    }
    
    func getCurrentLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

