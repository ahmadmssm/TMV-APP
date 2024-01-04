//
//  FunnelConnectSDKManager.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 03/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

protocol FunnelConnectSDKManager {
    func startFunnelConnectIfNeededOrUpdatePermissions(successAction: @escaping (String) -> (), errorAction: @escaping (String) -> ())
    func doIfSdkInitialized(successAction: @escaping () -> (), errorAction: @escaping (String) -> ())
    func isSdkInitialized() -> Bool
    func clearSavedData()
}
