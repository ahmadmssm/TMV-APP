//
//  TabbarItem.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 12/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TabbarItem<Content: View>: View {
    
    let label: String
    let iconName: String
    let index: Int
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        NavigationStack {
            content()
        }
        .tabItem {
            Label(self.label, systemImage: self.iconName)
        }
        .id(UUID())
    }
}
