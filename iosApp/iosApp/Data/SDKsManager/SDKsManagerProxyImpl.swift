//
//  SDKsManagerProxyImpl.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 02/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import utiqSDK
import funnelConnectSDK

class SDKsManagerProxyImpl: SDKsManagerProxy {
    
    private let utiqSDKManager: UTIQSDKManager
    private let funnelConnectSDKManager: FunnelConnectSDKManager
    
    init(utiqSDKManager: UTIQSDKManager, funnelConnectSDKManager: FunnelConnectSDKManager) {
        self.utiqSDKManager = utiqSDKManager
        self.funnelConnectSDKManager = funnelConnectSDKManager
    }
    
    func checkMNOEligibility(successAction: @escaping () -> (), errorAction: @escaping (String) -> ()) {
        self.utiqSDKManager.checkMNOEligibility(successAction: successAction, errorAction: errorAction)
    }
    
    func startFunnelConnectIfNeededOrUpdatePermissions(successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ()) {
        self.funnelConnectSDKManager.startFunnelConnectIfNeededOrUpdatePermissions(successAction: successAction, errorAction: errorAction)
    }
    
    func doIfFunnelConnectSdkInitialized(successAction: @escaping () -> (), errorAction: @escaping (String) -> ()) {
        self.funnelConnectSDKManager.doIfSdkInitialized(successAction: successAction, errorAction: errorAction)
    }
    
    func startUTIQIfNeededOrUpdateConsent() {
        self.utiqSDKManager.startUTIQIfNeededOrUpdateConsent()
    }
    
    func startUTIQIfNeededOrUpdateConsent(acceptConsent: Bool, successAction: @escaping (IdcData?) -> (), errorAction: @escaping (String) -> ()) {
        self.utiqSDKManager.startUTIQIfNeededOrUpdateConsent(acceptConsent: acceptConsent, successAction: successAction, errorAction: errorAction)
    }
    
    func clearSavedData() {
        self.utiqSDKManager.clearData()
        self.funnelConnectSDKManager.clearSavedData()
    }
    
    func isFunnelConnectSdkInitialized() -> Bool {
        self.funnelConnectSDKManager.isSdkInitialized()
    }
    
    func isConsentAccepted() -> Bool {
        self.utiqSDKManager.isConsentAccepted()
    }
    
    func getIdcData() -> IdcData? {
        self.utiqSDKManager.getIdcData()
    }
}
