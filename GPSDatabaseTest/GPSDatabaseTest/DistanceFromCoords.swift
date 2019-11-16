//
//  DistanceFromCoords.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 16/11/2019.
//  Copyright © 2019 Artturi Jalli. All rights reserved.
//

import Foundation
import CoreLocation

func distance(loc1: CLLocation, loc2: CLLocation) -> Double {
    return loc1.distance(from: loc2)
}
