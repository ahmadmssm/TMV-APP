//
//  TeavaroConsentViewViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Foundation

class TeavaroConsentViewViewModel: ObservableObject {
    
    @Published var marketingPermission = false
    @Published var analyticsPermission = false
    @Published var personalOffersPermission = false
    //
    private var localStorage: LocalStorage
    private let sdksManager: SDKsManagerProxy
    private let globalBottomSheetController: GlobalBottomSheetController
    
    init(localStorage: LocalStorage, sdksManager: SDKsManagerProxy, globalBottomSheetController: GlobalBottomSheetController) {
        self.localStorage = localStorage
        self.sdksManager = sdksManager
        self.globalBottomSheetController = globalBottomSheetController
        self.initPresets()
    }
    
    func acceptAllPermissions() {
        self.setAllPermissions(accepted: true)
        self.saveSettings()
    }
    
    func rejectAllPermissions() {
        self.setAllPermissions(accepted: false)
        self.saveSettings()
    }
    
    func saveSettings() {
        self.localStorage.seenTeavaroPopUp = true
        self.didSetPermissions()
    }
    
    private func setAllPermissions(accepted: Bool) {
        self.marketingPermission = accepted
        self.analyticsPermission = accepted
        self.personalOffersPermission = accepted
    }
    
    private func didSetPermissions() {
        self.localStorage.marketingPermissionAccepted = marketingPermission
        self.localStorage.analyticsPermissionAccepted = analyticsPermission
        self.localStorage.personalOffersPermissionAccepted = personalOffersPermission
        self.sdksManager.startFunnelConnectIfNeededOrUpdatePermissions { data in
            if let info = data.toDictionary(), info["state"] != nil, let umid = info["umid"] as? String {
                self.localStorage.umid = umid
            }
        } errorAction: { [weak self] in
            self?.globalBottomSheetController.post(message: $0)
        }
    }
    
    private func initPresets() {
        self.marketingPermission = self.localStorage.marketingPermissionAccepted
        self.analyticsPermission = self.localStorage.analyticsPermissionAccepted
        self.personalOffersPermission = self.localStorage.personalOffersPermissionAccepted
    }
}
