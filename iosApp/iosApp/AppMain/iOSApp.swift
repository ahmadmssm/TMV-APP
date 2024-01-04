//
//  iOSApp.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 20/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

@main
struct iOSApp: App {

    @State private var showSplashScreen = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashView(isActive: $showSplashScreen)
            }
            else {
                ContentView()
            }
        }
    }
}
