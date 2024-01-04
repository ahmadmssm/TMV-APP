//
//  SplashView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 24/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var isActive: Bool
    
    var body: some View {
        Image("splash_screen")
            .resizable()
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isActive = false
                    }
                }
            }
    }
}

#Preview {
    SplashView(isActive: .constant(true))
}
