//
//  Home.swift
//  Friendify
//
//  Created by Jesse Lindberg on 2.1.2020.
//  Copyright © 2020 Jesse's Evil Mega Corporation. All rights reserved.
//

import SwiftUI
import UIKit
import CoreBluetooth
import Combine

struct Home: View {
    
    @EnvironmentObject var peripherals: Peripherals
    var ble = BLECentralViewController()
    
    var body: some View {
        VStack {
            Button(action: {
                self.ble.viewDidLoad()
                //self.ble.startScan()
            }) {
                Text("Start Scanning")
            }
            Button(action: {
                print("Hello World!")
            }) {
                Text("Hello World")
            }
            //BluetoothScan(ble: ble)
            DeviceList()
        }
    }
}

/*
struct BluetoothScan: View {

    var ble = BLECentralViewController()
    
    var body: some View {
        Button(action: { self.ble.startScan() },
        label: { Text("Scan")})
    }
}
 */

struct Home_Previews: PreviewProvider {
    
    static let peripherals = Peripherals()
    static var previews: some View {
        Home().environmentObject(self.peripherals)
    }
}
