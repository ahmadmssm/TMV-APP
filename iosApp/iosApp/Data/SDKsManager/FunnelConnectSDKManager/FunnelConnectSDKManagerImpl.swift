//
//  FunnelConnectSDKManagerImpl.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 03/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import funnelConnectSDK

class FunnelConnectSDKManagerImpl: FunnelConnectSDKManager {
    
    private var localStorage: LocalStorage
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
    
    func clearSavedData() {
        self.localStorage.seenTeavaroPopUp = false
        self.localStorage.startedFunnelConnect = false
        self.localStorage.marketingPermissionAccepted = false
        self.localStorage.analyticsPermissionAccepted = false
        self.localStorage.personalOffersPermissionAccepted = false
        try? FunnelConnectSDK.shared.clearData()
        try? FunnelConnectSDK.shared.clearCookies()
        self.setOrUpdateFunnelConnectPermissions(successAction: { _ in }, errorAction: { _ in })
    }
    
    func startFunnelConnectIfNeededOrUpdatePermissions(successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ()) {
        if !self.localStorage.startedFunnelConnect {
            self.startFunnelConnect(successAction: { [weak self] data in
                self?.localStorage.startedFunnelConnect = true
                self?.setOrUpdateFunnelConnectPermissions(successAction: { string in
                    if let umid = self?.extractUmid(htmlString: data) ?? self?.extractUmid(htmlString: string) {
                        self?.localStorage.umid = umid
                        successAction(umid)
                    }
                    else {
                        successAction(string)
                    }
                }, errorAction: errorAction)
            }, errorAction: errorAction)
        }
        else {
            self.setOrUpdateFunnelConnectPermissions(successAction: successAction, errorAction: errorAction)
        }
    }
    
    func doIfSdkInitialized(successAction: @escaping () -> (), errorAction: @escaping (String) -> ()) {
        FunnelConnectSDK.shared.didInitializeWithResult(success: successAction, failure: {
            errorAction($0.localizedDescription)
        })
    }
    
    func isSdkInitialized() -> Bool {
        FunnelConnectSDK.shared.isInitialize()
    }
    
    private func extractUmid(htmlString: String) -> String? {
        if let info = htmlString.toDictionary(), info["state"] != nil {
            return info["umid"] as? String
        }
        return nil
    }
    
    private func setOrUpdateFunnelConnectPermissions(successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ()) {
        let permissions = ["CS-OM" : self.localStorage.marketingPermissionAccepted,
                           "CS-NBA" : self.localStorage.analyticsPermissionAccepted,
                           "CS-OPT" : self.localStorage.personalOffersPermissionAccepted]
        self.setPermissions(permissions: permissions, notificationsName: "MAIN_CS", successAction: successAction, errorAction: errorAction)
    }
    
    private func startFunnelConnect(successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ()) {
        FunnelConnectSDK.shared.startService { idcData in
            if let idfa = AppTracking.idfa {
                do {
                    try FunnelConnectSDK.shared.logEvent(key: "idfa", value: idfa)
                    successAction(idcData)
                }
                catch let error {
                    errorAction(error.localizedDescription)
                }
            }
        } errorCallback: {
            errorAction($0.localizedDescription)
        }
    }
    
    private func setPermissions(permissions: [String : Bool], notificationsName: String, successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ()) {
        let funnelConnectPermissions = Permissions()
        _ = permissions.map { (key, value) in
            funnelConnectPermissions.addPermission(key: key, accepted: value)
        }
        FunnelConnectSDK.shared.updatePermissions(permissions: funnelConnectPermissions, notificationsName: notificationsName, notificationsVersion: 1) {
            successAction($0)
        } errorCallback: {
            errorAction($0.localizedDescription)
        }
    }
}
