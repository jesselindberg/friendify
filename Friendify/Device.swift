//
//  SwiftUIView.swift
//  Friendify
//
//  Created by Jesse Lindberg on 26.12.2019.
//  Copyright © 2019 Jesse's Evil Mega Corporation. All rights reserved.
//

import SwiftUI
import CoreBluetooth
import Combine

/*
class Peripheral: CBPeripheral, Identifiable {
    let id = UUID()
    var name = String
}
 */

struct Device: Hashable, Identifiable {
    var id: UUID
    var name: String
    var peripheral_class: CBPeripheral
}

extension Device {
    
    init(peripheral: CBPeripheral) {
        id = peripheral.identifier
        name = peripheral.name ?? "Unknown device"
        peripheral_class = peripheral
    }
}

let foundDevices = [CBPeripheral]()
