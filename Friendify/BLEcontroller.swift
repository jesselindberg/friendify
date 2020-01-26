//
//  BLEController.swift
//  BLEscan
//
//  Created by Jesse Lindberg on 29/10/2019.
//  Copyright © 2019 Jesse's Evil Mega Corporation. All rights reserved.
//
import UIKit
import Foundation
import CoreBluetooth
import SwiftUI
import Combine

class BLECentralViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //centralManager = CBCentralManager(delegate: self, queue: nil)
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral!
    @EnvironmentObject var peripherals: Peripherals
    
    //var connectedDevices = [CBPeripheral]()
    var RSSIs = [NSNumber]()
    var connectedPeripherals = [CBPeripheral]()
    
    override func viewDidLoad() {
        print("Testing")
        super.viewDidLoad()
        let backgroundQueue = DispatchQueue.global(qos: .background)
        centralManager = CBCentralManager(delegate: self, queue: backgroundQueue)
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        print("Checking bluetooth state")
        
        switch centralManager.state {
            
        case .poweredOn:
            print("Bluetooth is ON")
            startScan()
        case .poweredOff:
            print("Bluetooth is OFF")
            let bluetoothAlert = UIAlertController(title: "Bluetooth is not enabled", message: "Please turn your Bluetooth on", preferredStyle: UIAlertController.Style.alert)
            let bluetoothAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            bluetoothAlert.addAction(bluetoothAction)
            self.present(bluetoothAlert, animated: true, completion: nil)
        case .unknown:
            print("Bluetooth status is unknown")
        case .resetting:
            print("Bluetooth status is resetting")
        case .unsupported:
            print("Bluetooth status is unsupported")
        case .unauthorized:
            print("Bluetooth status is unauthorized")
        @unknown default:
            print("Bluetooth status is unknown")
        }
    }
    
    public func startScan() {
        print("Starting scan...")
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    public func stopScanning() {

        self.centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral.name as Any)
        
        print(peripheral)
        
        self.blePeripheral = peripheral
        self.blePeripheral.delegate = self
        
        connectedPeripherals.append(peripheral)
        
        connectToDevice(peripheral: peripheral)
        
        let device = Device(peripheral: peripheral)
        
        print("Device ID:")
        print(device.id)
        print("Device name:")
        print(peripheral.name)
        print(device.name ?? "N/A")
        print("Device info:")
        print(device.peripheral_class)
        
        //peripherals.devices.append(device)
    }
    
    func connectToDevice (peripheral: CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("Connected!")
        print(connectedPeripherals)
        
        peripheral.discoverServices(nil)
        
        /*
        print("Device ID:")
        print(peripheral.identifier)
        print("Device name:")
        print(peripheral.name)
        print("Device info:")
        print(peripheral)
 */

        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        print("Discovered Services: \(services)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Discovering characteristics")
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Found \(characteristics.count) characteristics!")
        
        print(characteristics)
    
    }
}
