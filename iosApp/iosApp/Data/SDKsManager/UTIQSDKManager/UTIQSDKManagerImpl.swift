//
//  UTIQSDKManagerImpl.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 03/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import utiqSDK
import funnelConnectSDK

class UTIQSDKManagerImpl: UTIQSDKManager {
    
    private var localStorage: LocalStorage
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
    
    func checkMNOEligibility(successAction: @escaping () -> (), errorAction: @escaping (String) -> ()) {
        if UTIQ.shared.isInitialized() {
            UTIQ.shared.checkMNOEligibility(successCallback: successAction, errorCallback: {
                errorAction($0.localizedDescription)
            })
        }
        else {
            UTIQ.shared.didInitializeWithResult {
                UTIQ.shared.checkMNOEligibility(successCallback: successAction, errorCallback: {
                    errorAction($0.localizedDescription)
                })
            } failure: {
                errorAction($0.localizedDescription)
            }
        }
    }
    
    func clearData() {
        if self.localStorage.seenUTIQPopUp {
            self.localStorage.seenUTIQPopUp = false
            try? UTIQ.shared.clearData()
            try? UTIQ.shared.clearCookies()
            try? UTIQ.shared.rejectConsent()
        }
    }
    
    func isConsentAccepted() -> Bool {
        (try? UTIQ.shared.isConsentAccepted()) ?? false
    }
    
    func getIdcData() -> IdcData? {
        try? UTIQ.shared.idConnectData() as! IdcData
    }
    
    func startUTIQIfNeededOrUpdateConsent() {
        let acceptConsent = (try? UTIQ.shared.isConsentAccepted()) ?? false
        self.startUTIQIfNeededOrUpdateConsent(acceptConsent: acceptConsent, successAction: { _ in }, errorAction: { _ in})
    }
    
    func startUTIQIfNeededOrUpdateConsent(acceptConsent: Bool, successAction: @escaping (IdcData?) -> (), errorAction: @escaping (String) -> ()) {
        self.setOrUpdateUTIQPermissionInFunnelConnect(acceptConsent: acceptConsent, errorAction: { _ in })
        if acceptConsent {
            try? UTIQ.shared.acceptConsent()
            self.startUTIQIfNeeded(successAction: successAction, errorAction: errorAction)
        }
        else {
            try? UTIQ.shared.rejectConsent(successCallback: {
                successAction(nil)
            }, errorCallback: {
                errorAction($0.localizedDescription)
            })
        }
    }
    
    private func setOrUpdateUTIQPermissionInFunnelConnect(acceptConsent: Bool, errorAction: @escaping (String) -> ()) {
        var permissions: [String : Bool] = [:]
        if acceptConsent {
            permissions["CS-UTIQ"] = acceptConsent
        }
        else {
            permissions["CS-UTIQ"] = acceptConsent
        }
        self.setPermissions(permissions: permissions, notificationsName: "UTIQ_CS", errorAction: errorAction)
    }
    
    private func setPermissions(permissions: [String : Bool], notificationsName: String, errorAction: @escaping (String) -> ()) {
        let funnelConnectPermissions = Permissions()
        _ = permissions.map { (key, value) in
            funnelConnectPermissions.addPermission(key: key, accepted: value)
        }
        FunnelConnectSDK.shared.updatePermissions(permissions: funnelConnectPermissions, notificationsName: notificationsName, notificationsVersion: 1) { _ in } errorCallback: {
            errorAction($0.localizedDescription)
        }
    }
    
    private func startUTIQIfNeeded(successAction: @escaping (IdcData) -> (), errorAction: @escaping (String) -> ()) {
        if UTIQ.shared.isInitialized() {
            self.startUTIQ(successAction: successAction, errorAction: errorAction)
        }
        else {
            UTIQ.shared.didInitializeWithResult { [weak self] in
                self?.startUTIQ(successAction: successAction, errorAction: errorAction)
            } failure: {
                DebugLogger.log(tag: "Start UTIQ", message: $0.localizedDescription)
                errorAction($0.localizedDescription)
            }
        }
    }
    
    private func startUTIQ(successAction: @escaping (IdcData) -> (), errorAction: @escaping (String) -> ()) {
        UTIQ.shared.startService { [weak self] idcData in
            self?.localStorage.startedUTIQ = true
            successAction(idcData)
        } errorCallback: { [weak self] in
            DebugLogger.log(tag: "Start UTIQ", message: $0.localizedDescription)
            self?.localStorage.startedUTIQ = false
            errorAction($0.localizedDescription)
        }
    }
}
