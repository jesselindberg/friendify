//
//  DeviceList.swift
//  Friendify
//
//  Created by Jesse Lindberg on 26.12.2019.
//  Copyright © 2019 Jesse's Evil Mega Corporation. All rights reserved.
//

import SwiftUI
import CoreBluetooth
import Combine

struct DeviceList: View {
    @EnvironmentObject var peripherals: Peripherals
    
    var body: some View {
        List(peripherals.devices) { device in
            Text(device.name)
            //DeviceRow(device: device)
        }
        .navigationBarTitle(Text("Devices"))
    }
}

struct DeviceList_Previews: PreviewProvider {
    
    static let peripherals = Peripherals()
    
    static var previews: some View {
        DeviceList().environmentObject(self.peripherals)
    }
}
