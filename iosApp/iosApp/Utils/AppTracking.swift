//
//  AppTracking.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 03/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit
import AdSupport
import AppTrackingTransparency

struct AppTracking {
    
    private static var currentTrackingStatus: ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }
    
    static var isTrackingPermissionGranted: Bool {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            return true
        case .notDetermined,.restricted,.denied:
            return false
        @unknown default:
            return false
        }
    }
    
    static var idfa: String? {
        guard self.isTrackingPermissionGranted else {
            return nil
        }
        return self.getIDFA()
    }
    
    static func requestTrackingAuthorization(granted: @escaping (String) -> (), denied: @escaping (ATTrackingManager.AuthorizationStatus) -> ()) {
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    granted(self.getIDFA())
                }
                else {
                    // .denied, .notDetermined, .restricted
                    denied(status)
                }
            }
        }
    }
    
    static func openAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        UIApplication.shared.open(url)
    }
    
    private static func getIDFA() -> String {
        /*
         In iOS 14.5, the IDFA will be zeroed out if you try to access it without the user’s permission.
         Zeroed out IDFA:
         00000000-0000-0000-0000-000000000000
         */
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
