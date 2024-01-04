//
//  UTIQConsentViewViewMOdel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import utiqSDK
import Foundation

class UTIQConsentViewViewModel: ObservableObject {
    
    @Published var acceptConsent = false {
        willSet(newValue) {
            self.localStorage.seenUTIQPopUp = true
            self.sdksManager.startUTIQIfNeededOrUpdateConsent(acceptConsent: newValue) {
                DebugLogger.log(tag: "UTIQ IDC Data: MTID", message: $0?.mtid ?? "nil")
                DebugLogger.log(tag: "UTIQ IDC Data: ATID", message: $0?.atid ?? "nil")
            } errorAction: { [weak self] in
                self?.globalBottomSheetController.post(message: $0)
            }
        }
    }
    //
    private var localStorage: LocalStorage
    private let sdksManager: SDKsManagerProxy
    private let globalBottomSheetController: GlobalBottomSheetController
    
    init(sdksManager: SDKsManagerProxy, localStorage: LocalStorage, globalBottomSheetController: GlobalBottomSheetController) {
        self.sdksManager = sdksManager
        self.localStorage = localStorage
        self.globalBottomSheetController = globalBottomSheetController
    }
    
    func isConsentAccepted() -> Bool {
        self.sdksManager.isConsentAccepted()
    }
}
