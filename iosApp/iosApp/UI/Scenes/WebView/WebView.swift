//
//  WebView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 08/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    private let url: String
    
    fileprivate init(url: String) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string: self.url)!)
        webView.load(request)
    }
}

extension WebView {
    
    static func create(chapter: String?, url: String) -> some View {
        WebView(url: url)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Chapter \(chapter ?? "N/A")")
    }
    
    static func create(url: String) -> some View {
        WebView(url: url)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WebView(url: "www.google.com")
}
