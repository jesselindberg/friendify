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
    var device_data_from_DB: [String: Any] = [:]
    @IBAction func ShowLocations(_ sender: Any) {
        showDetectedDevices { (device_data) in
            self.device_data_from_DB = device_data as! [String : Any]
        }
        let device_distance_info = showDistanceBetweenDevicesInDB(device_data: device_data_from_DB)
        for info in device_distance_info{
            self.LocationsField.text! += info
        }
    }

    func showDistanceBetweenDevicesInDB(device_data: [String: Any]) -> [String]{
    var distances: [[String]] = []
        for (origin_name, locations) in device_data {
            let locations_dict = locations as! [String: Double]
            let coords_origin: CLLocation = CLLocation(latitude: locations_dict["latitude"]!, longitude: locations_dict["longitude"]!)
            let distance_data = device_data.map { (arg0) -> String in
                let (target_name, locs) = arg0
                if target_name != origin_name{
                    let loc_data = locs as! [String: Double]
                    let lat = loc_data["latitude"]!
                    let long = loc_data["longitude"]!
                    let coords_target = CLLocation(latitude: lat, longitude: long)
                    return "\(origin_name) - \(target_name): \(Double(distance(loc1: coords_origin, loc2: coords_target)).rounded())m \n"
                }
                return ""
            }
            distances.append(distance_data)
        }
        return distances.flatMap{ $0 }
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
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: Date())
    }
    
    func showDetectedDevices(completion: @escaping (_ result: Any) -> Void) -> [String: Any]{
        var all_data: [String: Any] = [:]
        let ref = Database.database().reference()
        let productRef = ref.child("DeviceData")
        productRef.observe(.childAdded) { (snapshot) in
            DispatchQueue.main.async {
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    var loc_data: [String: Double] = [:]
                    for elem in snap.children{
                        var data = elem as! DataSnapshot
                        if data.key != "timestamp"{
                            let d = data.value as! Double
                            loc_data["\(data.key)"] = d
                        }
                    }
                    if loc_data != [:]{
                        all_data["\(snapshot.key)"] = loc_data
                    }
                }
                completion(all_data)
            }
        }
        return all_data
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

