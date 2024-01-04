//
//  UIDevice+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

// Extensions to UIDevice based on ProcessInfo.processInfo.environment keys
// to determine if the app is running on an actual device or the Simulator.

extension UIDevice {
    
    static var isSimulator: Bool {
        let environment = ProcessInfo.processInfo.environment
        let isSimulator = environment["SIMULATOR_UDID"] != nil
        return isSimulator
    }
    
    static var isDevice: Bool {
        return !isSimulator
    }
}
