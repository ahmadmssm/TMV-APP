//
//  PopUpView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct PopUpView<ContentView: View>: View {
    
    @ViewBuilder private var contentView: ContentView
    private var didTabOutside: (() -> Void)?
    
    init(contentView:  ContentView,
         didTabOutside: (() -> Void)? = nil) {
        self.contentView = contentView
        self.didTabOutside = didTabOutside
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    self.didTabOutside?()
                }
            self.contentView
                .background(.white)
                .cornerRadius(15)
                .frame(width: UIScreen.width - 60, height: UIScreen.height - 100)
                .padding(.bottom, 20)
        }
    }
}

extension PopUpView {
    
    static func create(_ isPresented: Binding<Bool>,
                       shouldDismissOnTouchOutside: Bool = true,
                       contentView: ContentView) -> some View {
        PopUpView(contentView: contentView,
                  didTabOutside: {
            if shouldDismissOnTouchOutside {
                isPresented.wrappedValue = false
            }
        })
        .isHidden(!isPresented.wrappedValue)
    }
}

#Preview {
    PopUpView(contentView: EmptyView())
}
