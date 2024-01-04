//
//  ContentViewViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

class ContentViewViewModel: ObservableObject {
    
    @Published var idfaProvided = false
    @Published var showUTIQPopUp = false
    @Published var showTeavaroPopUp = false {
        willSet(newValue) {
            if newValue == false {
                self.showUTIQPopUpIfNeededOrStartUtiqService()
            }
        }
    }
    //
    private var localStorage: LocalStorage
    private let sdksManagerProxy: SDKsManagerProxy
    
    init(localStorage: LocalStorage, sdksManagerProxy: SDKsManagerProxy) {
        self.localStorage = localStorage
        self.sdksManagerProxy = sdksManagerProxy
    }
    
    func onFirstAppear() {
        // Only show the flow if the SDK popup is initialized.
        if self.sdksManagerProxy.isFunnelConnectSdkInitialized() {
            self.showATTIfNeededOrShowTeavaroPopUp()
        }
        else {
            self.sdksManagerProxy.doIfFunnelConnectSdkInitialized {
                self.showATTIfNeededOrShowTeavaroPopUp()
            } errorAction: {
                DebugLogger.log(tag: "FunnelConnectSdk Intialization Failed", message: $0)
            }
        }
    }
    
    private func showATTIfNeededOrShowTeavaroPopUp() {
        if !AppTracking.isTrackingPermissionGranted {
            AppTracking.requestTrackingAuthorization { [weak self] idfa in
                self?.idfaProvided = true
                self?.showTeavaroPopUpIfNeeded()
            } denied: { [weak self] _ in
                self?.idfaProvided = false
                // Call it anyway
                self?.showTeavaroPopUpIfNeeded()
            }
        }
        else {
            self.showTeavaroPopUpIfNeeded()
        }
    }
    
    private func showTeavaroPopUpIfNeeded() {
        if !self.localStorage.seenTeavaroPopUp {
            self.showTeavaroPopUp = true
        }
        else {
            self.showUTIQPopUpIfNeededOrStartUtiqService()
        }
    }
    
    private func showUTIQPopUpIfNeededOrStartUtiqService() {
        if self.localStorage.atLeastOneTeavarPermissionAccepted() {
            self.sdksManagerProxy.checkMNOEligibility { [weak self] in
                guard let self = self else { return }
                if !self.localStorage.seenUTIQPopUp  {
                    self.showUTIQPopUp = true
                }
                else {
                    self.sdksManagerProxy.startUTIQIfNeededOrUpdateConsent()
                }
            } errorAction: { [weak self] error in
                self?.showUTIQPopUp = false
                DebugLogger.log(tag: "UTIQ Popup", message: error)
            }
        }
    }
}
