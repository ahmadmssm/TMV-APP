//
//  EnvironmentVariables.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import kmmSharedModule

enum EnvironmentVariables {
    @InfoPlistVariable(key: "CFBundleShortVersionString")
    static var appVersion: String
    static var utiqToken = BuildKonfig.shared.utiqToken
    static var funnelConnectToken = BuildKonfig.shared.funnelConnectToken
}
