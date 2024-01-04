//
//  TeavaroConsentView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory

struct TeavaroConsentView: View {
    
    @InjectedObject(\.teavaroConsentViewViewModel)
    private var viewModel: TeavaroConsentViewViewModel
    @Binding
    private var isPresented: Bool
    @Environment(\.dismiss)
    private var dismiss
    private var title: String {
        if self.$isPresented.wrappedValue {
            ""
        }
        else {
            "Teavaro Privacy Settings"
        }
    }
    
    init(isPresented: Binding<Bool> = .constant(false)) {
        _isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Image("manga_icon")
                        .resizable()
                        .padding(.leading)
                        .padding(.top)
                        .frame(width: 75, height: 75)
                    Text("Teavaro Manga Viewer App is all about your Privacy")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(self.labelColor())
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                    self.createSection(title: "Marketing and Social Network",
                                       body: "Enhance your browsing experience. Our cookies evaluate your behavior and present relevant offers. They also enable valuable insights for advertisers and publishers. We share this information with trusted analytics, marketing, and social media partners. If you're logged in to a social network, your user profile may be enriched with your surfing behavior.",
                                       binding: $viewModel.marketingPermission)
                    Divider()
                    self.createSection(title: "Analytics Cookies",
                                       body: "Enhance your experience. Our cookies improve our website by analyzing visitor behavior, such as page duration and return frequency.",
                                       binding: $viewModel.analyticsPermission)
                    Divider()
                    self.createSection(title: "Personal Offers",
                                       body: "Seamless personalization across devices. Our cookie-based identification assigns your profile to all recognized devices, ensuring consistent settings and personalized offers. Your surfing behavior is not utilized for this purpose. Registering for our newsletter allows us to identify you and link it to your profile.",
                                       binding: $viewModel.personalOffersPermission)
                }
            }
            HStack(spacing: 10) {
                Text("Accept All")
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.green, lineWidth: 1)
                            .background(Color.green.cornerRadius(10))
                    )
                    .onTapGesture {
                        self.viewModel.acceptAllPermissions()
                        self.dismissView()
                    }
                Text("Reject All")
                    .foregroundColor(.green)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.green, lineWidth: 1)
                            .background(Color.white.cornerRadius(10))
                    )
                    .onTapGesture {
                        self.viewModel.rejectAllPermissions()
                        self.dismissView()
                    }
            }
            .frame(maxWidth: .infinity)
            Spacer()
                .frame(height: 10)
            Text("Save Settings")
                .foregroundColor(.white)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 1)
                        .background(Color.blue.cornerRadius(10))
                )
                .onTapGesture {
                    self.viewModel.saveSettings()
                    self.dismissView()
                }
            Spacer()
                .frame(height: 20)
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .navigationTitle(self.title)
    }
    
    private func createSection(title: String, body: String, binding: Binding<Bool>) -> some View {
        VStack(alignment: .leading) {
            Toggle(title, isOn: binding)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(self.labelColor())
            ExpandableText(body)
                .lineLimit(2)
                .moreButtonFont(.system(size: 14, weight: .bold))
                .moreButtonText("read more")
                .moreButtonColor(.blue)
                .foregroundColor(self.labelColor())
                .expandAnimation(.easeInOut(duration: 1))
                .trimMultipleNewlinesWhenTruncated(false)
                .font(.system(size: 14))
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
    
    private func labelColor() -> Color {
        if self.isPresented { .black } else { .white }
    }
    
    private func dismissView() {
        if self.$isPresented.wrappedValue {
            self.isPresented = false
        }
        else {
            self.dismiss()
        }
    }
}

extension TeavaroConsentView {
    
    static func create(_ isPresented: Binding<Bool>) -> some View {
        PopUpView.create(isPresented,
                         shouldDismissOnTouchOutside: false,
                         contentView: TeavaroConsentView(isPresented: isPresented))
    }
}

#Preview {
    TeavaroConsentView()
}

#Preview {
    TeavaroConsentView.create(.constant(true))
}
