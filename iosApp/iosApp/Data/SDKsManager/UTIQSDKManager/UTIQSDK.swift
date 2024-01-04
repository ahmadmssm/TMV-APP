//
//  UTIQSDK.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 03/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import utiqSDK

protocol UTIQSDKManager {
    func checkMNOEligibility(successAction: @escaping () -> (), errorAction: @escaping (String) -> ()) 
    func startUTIQIfNeededOrUpdateConsent()
    func startUTIQIfNeededOrUpdateConsent(acceptConsent: Bool, successAction: @escaping (IdcData?) -> (), errorAction: @escaping (String) -> ())
    func clearData()
    func isConsentAccepted() -> Bool
    func getIdcData() -> IdcData?
}
