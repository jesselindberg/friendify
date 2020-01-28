//
//  deviceRow.swift
//  Friendify
//
//  Created by Jesse Lindberg on 26.12.2019.
//  Copyright © 2019 Jesse's Evil Mega Corporation. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct DeviceRow: View {
    //@EnvironmentObject var peripherals: Peripherals
    var device: Device
    
    var body: some View {
        HStack {
            Text(device.name)
            Spacer()
        }
    }
}

//struct DeviceRow_Previews: PreviewProvider {
//    static var peripherals = Peripherals()
//    static var previews: some View {
//        Group {
//            DeviceRow(device: peripherals.devices[0])
//            DeviceRow(device: peripherals.devices[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
