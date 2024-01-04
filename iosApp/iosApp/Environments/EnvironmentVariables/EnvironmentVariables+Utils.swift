//
//  EnvironmentVariables+Utils.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

extension EnvironmentVariables {
    
    static var appId: String {
        return Bundle.main.bundleIdentifier!
    }
    
    static var isDebugEnv: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var isProductionEnv: Bool {
        #if PRODUCTION
        return true
        #else
        return false
        #endif
    }
    
    static func doIfDebugEnv(action: () -> ()) {
        #if DEBUG
        action()
        #endif
    }
    
    static func doIfDebugEnv(action: () -> (), elseAction: () -> ()) {
        #if DEBUG
        action()
        #else
        elseAction()
        #endif
    }
}
