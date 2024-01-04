//
//  SDKsManagerProxy.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 02/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import utiqSDK

protocol SDKsManagerProxy {
    func checkMNOEligibility(successAction: @escaping () -> (), errorAction: @escaping (String) -> ()) 
    func startFunnelConnectIfNeededOrUpdatePermissions(successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ())
    func doIfFunnelConnectSdkInitialized(successAction: @escaping () -> (), errorAction: @escaping (String) -> ())
    func startUTIQIfNeededOrUpdateConsent()
    func startUTIQIfNeededOrUpdateConsent(acceptConsent: Bool, successAction: @escaping (IdcData?) -> (), errorAction: @escaping (String) -> ())
    func clearSavedData()
    func isFunnelConnectSdkInitialized() -> Bool
    func isConsentAccepted() -> Bool
    func getIdcData() -> IdcData?
}
