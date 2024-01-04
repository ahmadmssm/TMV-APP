//
//  ChapterView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory
import SwiftUIPager

struct ChapterView: View {
    
    let chapterId: String
    let externalUrl: String?
    let chapterNumber: String?
    @InjectedObject(\.chapterViewViewModel)
    private var viewModel: ChapterViewViewModel
    @StateObject
    private var page: Page = .first()
    @State
    private var scale: CGFloat = 1.0
    @State
    private var maxScale: CGFloat = 4.0
    private var navigationBarTitle: String {
        if let chapterNumber, !chapterNumber.isEmpty {
            return "Chapter \(chapterNumber)"
        }
        else {
            return "Latest Chapter"
        }
    }
    
    var body: some View {
        if let externalUrl {
            WebView.create(chapter: self.chapterNumber, url: externalUrl)
        }
        else {
            VStack {
                Pager(page: page, data: self.viewModel.chapterPagesURLs, id: \.self, content: { pageUrl in
                    CardView {
                        Image
                            .createWithAspectFill(url: pageUrl)
                            .addPinchZoomWith(scale: $scale, maxAllowedScale: $maxScale)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                })
                .itemSpacing(5)
                .interactive(scale: 0.7)
                .interactive(rotation: true)
                .draggingAnimation(.interactive)
                Text("Page \(page.index + 1) of \(self.viewModel.chapterPagesURLs.count)")
                Spacer(minLength: 20)
            }
            .navigationTitle(self.navigationBarTitle)
            .onFirstAppear {
                self.viewModel.fetchChapterPages(chapterId: chapterId)
            }
            
        }
    }
}

#Preview {
    ChapterView(chapterId: "41f8420b-1225-4d61-bdbe-99cd89cef923", externalUrl: "https://www.google.com/", chapterNumber: "20")
}
