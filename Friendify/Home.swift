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
    let viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Button("Start scanning", action: viewModel.startButtonPressed)
            Button("Hello World!", action: viewModel.helloWorldButtonPressed)
            //BluetoothScan(ble: ble)
            DeviceList(viewModel: DeviceListViewModel(bleService: viewModel.bleService))
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
    static var previews: some View {
        Home(viewModel: HomeViewModel(bleService: BLEService()))
    }
}
