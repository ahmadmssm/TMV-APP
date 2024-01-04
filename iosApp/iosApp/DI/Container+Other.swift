//
//  Container+Other.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 12/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Factory
import kmmSharedModule

extension Container {
    
    private var utiqSDKManager: Factory<UTIQSDKManager> {
        self {
            UTIQSDKManagerImpl(localStorage: self.localStorage())
        }
    }
    
    private var funnelConnectSDKManager: Factory<FunnelConnectSDKManager> {
        self {
            FunnelConnectSDKManagerImpl(localStorage: self.localStorage())
        }
    }
    
    private var logger: Factory<SystemLogger> {
        self {
            LoggerImpl(enableLogging: EnvironmentVariables.isDebugEnv)
        }
    }
    
    private var restClient: Factory<RestClient> {
        self {
            HttpClientFactory(logger: self.logger()).create()
        }
    }
    
    var apiFactory: Factory<APIFactory> {
        self {
            APIFactory(restClient: self.restClient())
        }.singleton
    }
    
    var localStorage: Factory<LocalStorage> {
        self {
            LocalStorageImpl()
        }.singleton
    }
    
    var sdksManagerProxy: Factory<SDKsManagerProxy> {
        self {
            SDKsManagerProxyImpl(utiqSDKManager: self.utiqSDKManager(), funnelConnectSDKManager: self.funnelConnectSDKManager())
        }.singleton
    }
    
    var globalBottomSheetController: Factory<GlobalBottomSheetController> {
        self {
            GlobalBottomSheetController()
        }.singleton
    }
    
    var networkUtils: Factory<NetworkUtils> {
        self {
            self.networkConnectivityObserver()
        }
    }
    
    var networkConnectivityObserver: Factory<NetworkConnectivityObserver> {
        self {
            NetworkConnectivityObserver()
        }.graph
    }
}
