//
//  CardView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 10/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct CardView<ContentView: View>: View {
    
    @ViewBuilder var content: () -> ContentView
    
    var body: some View {
        GroupBox {
            content()
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}
