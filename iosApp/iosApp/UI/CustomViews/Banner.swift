//
//  Banner.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 02/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct BannerParams {
    var title: String
    var detail: String
    var type: BannerType
    var isVisible: Bool
}

enum BannerType {
    
    case info
    case warning
    case success
    case error
    
    var tintColor: Color {
        switch self {
        case .info:
            return .init(red: 67/255, green: 154/255, blue: 215/255)
        case .success:
            return .green
        case .warning:
            return .yellow
        case .error:
            return .red
        }
    }
}

struct BannerModifier: ViewModifier {
    
    @Binding var params: BannerParams
    @State var task: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack {
            content
            if params.isVisible {
                VStack {
                    HStack {
                        Spacer()
                        if !params.title.isEmpty {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(params.title)
                                    .bold()
                            }
                            if !params.detail.isEmpty {
                                Text(params.detail)
                            }
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .background(params.type.tintColor)
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    Spacer()
                }
                .zIndex(1)
                .padding()
                .animation(.easeInOut(duration: 0.5))
                .padding(.top, -3)
                .transition(.slide)
                .onTapGesture {
                    withAnimation {
                        self.params.isVisible = false
                    }
                }
                .onAppear {
                    self.task = DispatchWorkItem {
                        withAnimation {
                            self.params.isVisible = false
                        }
                    }
                    // Auto dismiss after 5 seconds, and cancel the task if view disappear before the auto dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: self.task!)
                }
                .onDisappear {
                    self.task?.cancel()
                }
            }
        }
    }
}

extension View {
    func banner(params: Binding<BannerParams>) -> some View {
        self.modifier(BannerModifier(params: params))
    }
}
