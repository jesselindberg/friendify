//
//  CBController.swift
//  Friendify
//
//  Created by Jesse Lindberg on 15.1.2020.
//  Copyright © 2020 Jesse's Evil Mega Corporation. All rights reserved.
//

// NOT IN USE!

import Foundation
import CoreBluetooth
import UIKit
import SwiftUI
import Combine
/*

protocol BluetoothServiceDelegate: class {

    /// Called when 'CBCentralManager' changes state
    func didPowerStateUpdate(isPowerOn: Bool)

    /// Called when eather new device has been discovered or rssi value of the existing has been updated
    func didDeviceUpdate()

    /// Called when 'CBCentralManager' connects or disconnects from the device
    func didDeviceConnectionUpdate()
    
    /// Called when steps changed
    func didStepsUpdate(steps: Int)
}


class BluetoothService: UIViewController {
    
    private var centralManager: CBCentralManager
    @EnvironmentObject var peripherals: Peripherals
        
    var connectedDevices = [CBPeripheral]()
    var RSSIs = [NSNumber]()
    
    public weak var delegate: BluetoothServiceDelegate?

/*
    public override init() {
        super.init()
        
        /** Best Practice
            Perform Bluetooth tasks on background queue */
        let backgroundQueue = DispatchQueue.global(qos: .background)
        self.centralManager = CBCentralManager(delegate: self, queue: backgroundQueue)
    }
 */
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    public func startScan() {
        if self.isPowerOn() {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    public func stopScanning() {
        if self.isScanning() {
            centralManager.stopScan()
        }

        /** Best Practice
            Stop scanning when we don't need to */
        self.centralManager.stopScan()
    }
    
    public func isPowerOn() -> Bool {
        return self.centralManager.state == .poweredOn
    }
    
    public func isScanning() -> Bool {
        return self.centralManager.isScanning
    }
}

extension BluetoothService: CBCentralManagerDelegate {
        
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        DispatchQueue.main.async {
            self.delegate?.didPowerStateUpdate(isPowerOn: central.state == .poweredOn)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        peripherals.list.append(peripheral)
        self.RSSIs.append(RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
}

*/
