//
//  MoreViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 08/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

class MoreViewModel: ObservableObject {
    
    @Published var isEligibleToUseUTIQ = false
    @Published var showUTIQPrivacySettings = false
    //
    private var localStorage: LocalStorage
    private let sdksManagerProxy: SDKsManagerProxy
    
    init(localStorage: LocalStorage, sdksManagerProxy: SDKsManagerProxy) {
        self.localStorage = localStorage
        self.sdksManagerProxy = sdksManagerProxy
        self.checkMNOEligibility()
    }
    
    func onAppera() {
        self.showUTIQPrivacySettings = self.localStorage.atLeastOneTeavarPermissionAccepted() && self.localStorage.startedUTIQ
    }
    
    func clearData() {
        self.sdksManagerProxy.clearSavedData()
    }
    
    func contactUs() {
        Email.contactSupport()
    }
    
    private func checkMNOEligibility() {
        self.sdksManagerProxy.checkMNOEligibility { [weak self] in
            self?.isEligibleToUseUTIQ = true
        } errorAction: { [weak self] error in
            self?.isEligibleToUseUTIQ = false
            DebugLogger.log(tag: "UTIQ MNO Eligibility => More Tab", message: error)
        }
    }
}
