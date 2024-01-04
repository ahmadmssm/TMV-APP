//
//  LocalStorageImpl.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

class LocalStorageImpl: LocalStorage {
    
    @AppStorage("umid")
    var umid: String = ""
    @AppStorage("seenTeavaroPopUp")
    var seenTeavaroPopUp = false
    @AppStorage("startedUTIQ")
    var startedUTIQ = false
    @AppStorage("startedFunnelConnect")
    var startedFunnelConnect = false
    @AppStorage("seenUTIQPopUp")
    var seenUTIQPopUp = false
    @AppStorage("marketingPermission")
    var marketingPermissionAccepted = false
    @AppStorage("analyticsPermission")
    var analyticsPermissionAccepted = false
    @AppStorage("personalOffersPermission")
    var personalOffersPermissionAccepted = false
    
    func atLeastOneTeavarPermissionAccepted() -> Bool {
        self.analyticsPermissionAccepted || self.marketingPermissionAccepted || self.personalOffersPermissionAccepted
    }
}
