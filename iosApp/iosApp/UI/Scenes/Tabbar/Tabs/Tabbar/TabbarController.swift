//
//  TabbarController.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 11/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

class TabbarController: ObservableObject {
    
    @Published var selectedTabIndex = 0
    var selectedTabHandler: Binding<Int> { Binding(
        get: { self.selectedTabIndex },
        set: {
            if $0 == self.selectedTabIndex {
                print("Selected Tab Index \(self.selectedTabIndex)")
            }
            self.selectedTabIndex = $0
        }
    )}
}
