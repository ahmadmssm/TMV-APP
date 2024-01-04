//
//  AppDelegate.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 19/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit
import Pulse
import PulseUI
import utiqSDK
import funnelConnectSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.removeNavigationBarBackButtonLabel()
        self.initHttpRequestsMonitorIfDebug()
        self.initUTIQSDK()
        self.initFunnelConnectSDK()
        return true
    }
    
    private func removeNavigationBarBackButtonLabel() {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    }
    
    private func initHttpRequestsMonitorIfDebug() {
        EnvironmentVariables.doIfDebugEnv {
            URLSessionProxyDelegate.enableAutomaticRegistration()
            UserSettings.shared.lineLimit = 5
            UserSettings.shared.isLinkDetectionEnabled = true
        }
    }
    
    private func initUTIQSDK() {
        let options = UTIQOptions(enableLogging: EnvironmentVariables.isDebugEnv ? true : false)
        UTIQ.shared.initialize(sdkToken: EnvironmentVariables.utiqToken, options: options)
    }
    
    private func initFunnelConnectSDK() {
        let options = FCOptions(enableLogging: EnvironmentVariables.isDebugEnv ? true : false)
        FunnelConnectSDK.shared.initialize(sdkToken: EnvironmentVariables.funnelConnectToken, options: options)
    }
}
