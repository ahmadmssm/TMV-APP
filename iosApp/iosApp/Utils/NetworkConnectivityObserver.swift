//
//  NetworkConnectivityObserver.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 11/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Network
import Foundation
import SwiftUI
import kmmSharedModule
import SystemConfiguration

class NetworkConnectivityObserver: ObservableObject, NetworkUtils {
    
    private var isFirstTime = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    //
    @Published private(set) var isConnected = false
    @Published private(set) var isConnectedToCellular = false
    @Published var banner: BannerParams = .init(title: "", detail: "", type: .warning, isVisible: false)
    
    init() {
        self.observe()
    }
    
    func isInternetConnectionAvailable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    private func observe() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if let self {
                    self.isConnectedToCellular = path.usesInterfaceType(.cellular)
                    // Testing on simulator might return wrong status so plase test on a pysical device.
                    if path.status == .satisfied {
                        self.isConnected = true
                        self.setBannerState(isConnected: true)
                    } else {
                        self.isConnected = false
                        self.setBannerState(isConnected: false)
                    }
                }
            }
        }
        self.monitor.start(queue: self.queue)
    }
    
    private func setBannerState(isConnected: Bool) {
        if !self.isFirstTime  {
            self.banner = BannerParams(title: "Internet \(isConnected ? "connected" : "disconnected")", detail: "", type: isConnected ? .info : .warning, isVisible: isConnected ? false : true)
        }
        else {
            self.isFirstTime = false
        }
    }
}
