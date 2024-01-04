//
//  ChaptersListingView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory
import kmmSharedModule

struct ChaptersListingView: View {
    
    let mangaId: String
    let mangaName: String
    @InjectedObject(\.chaptersListingViewModel)
    private var viewModel: ChaptersListingViewModel
    
    var body: some View {
        VStack {
            List(self.viewModel.chapters) { chapter in
                CardView {
                    ChaptersListingRowView(chapterPages: chapter.attributes.pages,
                                           publishAt: chapter.attributes.formattedPublishAt,
                                           chapterNumber: chapter.attributes.chapterNumber ?? "N/A",
                                           chapterLanguage: chapter.attributes.language ?? "N/A")
                    .background(Color(.systemGray5))
                    
                }
                .onTapNavigate(to: ChapterView(chapterId: chapter.id, externalUrl: chapter.attributes.externalUrl, chapterNumber: chapter.attributes.chapterNumber), hideNavigationArrow: true)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.bottom, 10)
                .onAppear {
                    self.viewModel.loadMoreIfNeeded(currentChapter: chapter)
                }
            }
            .padding(.top, 10)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .animation(.default, value: self.viewModel.chapters)
            .refreshable {
                self.viewModel.reloadFromScratch()
            }
            ProgressView()
                .frame(width: UIScreen.width - 40, height: 30, alignment: .center)
                .isHidden(self.viewModel.hideBottomLoader, remove: self.viewModel.hideBottomLoader)
            Spacer()
        }.onFirstAppear {
            self.viewModel.set(mangaId: self.mangaId)
        }
        .navigationTitle(self.mangaName)
        .banner(params: $viewModel.banner)
    }
}

#Preview {
    ChaptersListingView(mangaId: "d5e0431b-3410-4bbe-a147-4ce50fb21bd6", mangaName: "Naruto")
}
