//
//  UTIQConsentView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory

struct UTIQConsentView: View {
    
    @InjectedObject(\.utiqConsentViewViewModel)
    private var viewModel: UTIQConsentViewViewModel
    @Binding
    private var isPresented: Bool
    @Environment(\.dismiss)
    private var dismiss
    //
    private var expandableTextViewConstant: Int {
        // Why 4x -> Screen height is returned as points, and we need the scale in tenth instead of hundreds, so we divide by 5x10
        let asepctRatio = UIScreen.height/UIScreen.width
        let roundedAspectRatio = asepctRatio.round(to: 2)
        let smallScreenRoundedAspectRatio = (16/9).round(to: 2)
        let factor = if (roundedAspectRatio == smallScreenRoundedAspectRatio) { 45 } else { 41 }
        return Int(UIScreen.height)/factor
    }
    private var title: String {
        if self.$isPresented.wrappedValue {
            ""
        }
        else {
            "UTIQ Privacy Settings"
        }
    }
    
    private let telocIconNames = ["congstar_logo", "vfde_logo", "frnk_logo", "dtde_logo"]
    
    init(isPresented: Binding<Bool> = .constant(false)) {
        _isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            HStack {
                Image("utiq-logo")
                    .frame(alignment: .leading)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                Text("Consent to use the Utiq service on Teavaro Manga Viewer")
                    .foregroundColor(self.labelColor())
                    .font(.system(size: 17, weight: .black))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                    .frame(height: 5)
                ExpandableText("By giving your consent, you activate the Utiq service. This allows this website to offer you personalised experiences or perform analytics while you retain control of your data. In the consenthub listed below you can manage your settings for Utiq and revoke all Utiq consents. With your consent, you agree to the following data processing:\n\nYour network operator uses your IP address to check whether the requirements for using the service are met. If this is true, it will generate a so-called network signal. This is a pseudonymous identifier.\n\nUtiq uses the network signal to generate another random value, called consentpass. This is used to manage the Utiq service and Utiq consents.\n\nTeavaro Manga Viewer only receives two so-called marketing signals from Utiq. These are used to show you personalized content, advertisement, and to carry out analyses.\n\nThese so-called marketing signals are random values ​​created by Utiq, called martechpass and adtechpass. They enable this app to recognize you as the same visitor without revealing your identity, to offer you personalized content and advertising or carry out analyses. The martechpass and adtechpass are stored in your app together with a corresponding “first party cookies” and expire after 90 days. If you have given your consent to other Teavaro app, the same martechpass is also available for these apps.\n\nFurther information about the Utiq service and our partnerships can be found in the Utiq privacy policy or by clicking on your network provider logo below.")
                    .font(.system(size: 13))
                    .lineLimit(self.expandableTextViewConstant)
                    .moreButtonFont(.system(size: 13, weight: .bold))
                    .moreButtonText("read more")
                    .moreButtonColor(.blue)
                    .foregroundColor(self.labelColor())
                    .expandAnimation(.easeInOut(duration: 1))
                    .trimMultipleNewlinesWhenTruncated(false)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top)
            Spacer()
                .frame(height: 15)
            VStack(alignment: .center) {
                if !self.viewModel.isConsentAccepted() {
                    self.createRoundedCorneresButton(text: "Accept") {
                        self.viewModel.acceptConsent = true
                        self.dismissView()
                    }
                    Spacer()
                        .frame(height: 15)
                }
                self.createRoundedCorneresButton(text: "Reject") {
                    self.viewModel.acceptConsent = false
                    self.dismissView()
                }
                Spacer()
                    .frame(height: 15)
                HStack(alignment: .center) {
                    Text("[Utiq’s Privacy Statement](https://consenthub.utiq.com/pages/privacy-statement)")
                        .font(.system(size: 14))
                    Text("&")
                        .font(.system(size: 14))
                        .foregroundColor(self.labelColor())
                    Text("[consenthub](https://consenthub.utiq.com)")
                        .font(.system(size: 14))
                }
            }
            HStack(alignment: .center, spacing: 40) {
                ForEach(self.telocIconNames, id: \.self) {
                    Image($0)
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
                .frame(height: 15)
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .navigationTitle(self.title)
    }
    
    private func createRoundedCorneresButton(text: String, action: @escaping () -> ()) -> some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(.white)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(.red)
            .clipShape(Capsule())
            .padding(.leading, 50)
            .padding(.trailing, 50)
            .onTapGesture {
                action()
            }
    }
    
    private func createIcon(iconName: String) -> some View {
        Image(iconName)
            .resizable()
            .frame(width: 35, height: 35)
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

extension UTIQConsentView {
    
    static func create(_ isPresented: Binding<Bool>) -> some View {
        PopUpView.create(isPresented,
                         shouldDismissOnTouchOutside: false,
                         contentView: UTIQConsentView(isPresented: isPresented))
    }
}

#Preview {
    UTIQConsentView()
}

#Preview {
    UTIQConsentView.create(.constant(true))
}
