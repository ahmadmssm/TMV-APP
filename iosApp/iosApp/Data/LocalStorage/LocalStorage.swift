//
//  LocalStorage.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

protocol LocalStorage {
    
    var umid: String { get set }
    var seenTeavaroPopUp: Bool { get set }
    var startedUTIQ: Bool { get set }
    var startedFunnelConnect: Bool { get set }
    var seenUTIQPopUp: Bool { get set }
    var marketingPermissionAccepted: Bool { get set }
    var analyticsPermissionAccepted: Bool { get set }
    var personalOffersPermissionAccepted: Bool { get set }
    
    func atLeastOneTeavarPermissionAccepted() -> Bool
}
