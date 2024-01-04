//
//  DebugLogger.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 01/12/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Pulse

struct DebugLogger {
    
    static func log(tag: String, message: String) {
        EnvironmentVariables.doIfDebugEnv {
            LoggerStore.shared.storeMessage(label: tag, level: .debug, message: message, metadata: [:])
        }
    }
}
