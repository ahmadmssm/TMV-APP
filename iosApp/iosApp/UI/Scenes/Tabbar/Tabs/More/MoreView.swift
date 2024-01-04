//
//  MoreView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 08/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import PulseUI
import Factory

struct MoreView: View {
    
    @InjectedObject(\.moreViewModel)
    private var viewModel: MoreViewModel
    @State
    private var showCredits = false
    @State
    private var showAbouTeavaro = false
    @State
    private var showClearDataAlert = false
    
    var body: some View {
        List {
            Text("Manage Teavaro Privacy Settings")
                .onTapNavigate(to: TeavaroConsentView())
            if self.viewModel.showUTIQPrivacySettings && self.viewModel.isEligibleToUseUTIQ {
                Text("Manage UTIQ Privacy Settings")
                    .onTapNavigate(to: UTIQConsentView())
            }
            Text("[Privacy Policy](https://tv-public-file.s3.eu-central-1.amazonaws.com/teavaro-manga-viewer-privacy-policy.html)")
            Text("[Terms and Conditions](https://tv-public-file.s3.eu-central-1.amazonaws.com/teavaro-manga-viewer-terms-conditions.html)")
            Text("Clear Data")
                .alert(isPresented: $showClearDataAlert) { () -> Alert in
                    Alert(title: Text("Clear Data!"), message: Text("Are you sure you want to delete the cached data and reset accepted permissions ?"), primaryButton: .default(Text("OK"), action: {
                        self.clearDataConfirmed()
                    }), secondaryButton: .default(Text("Cancel")))
                }
                .onTapGesture {
                    self.showClearDataAlert = true
                }
            if (EnvironmentVariables.isDebugEnv) {
                Text("HTTP Logger")
                    .onTapNavigate(to: ConsoleView().closeButtonHidden())
            }
            Text("Credits")
                .onTapGesture {
                    self.showCredits = true
                }
                .sheet(isPresented: self.$showCredits) {
                    VStack {
                        Text("Backed by [MangaDex APIs]( https://api.mangadex.org/docs/)")
                    }
                    .presentationDetents([.height(50)])
                }
            Text("Version \(EnvironmentVariables.appVersion)")
            Text("Contact Us")
                .onTapGesture {
                    self.viewModel.contactUs()
                }
            Text("[About Teavaro](https://teavaro.com/)")
        }
        .removeTopPadding()
        .navigationTitle("More")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.viewModel.onAppera()
        }
    }
    
    private func clearDataConfirmed() {
        self.viewModel.clearData()
        Alert(title: Text("Data Cleared Successfully!"),
              message: nil,
              dismissButton: nil)
    }
}

#Preview {
    MoreView()
}
