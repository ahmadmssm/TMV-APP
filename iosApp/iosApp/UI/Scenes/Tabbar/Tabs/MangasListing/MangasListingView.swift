//
//  MangasListingView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 19/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory
import kmmSharedModule

struct MangasListingView: View {
    
    @InjectedObject(\.mangasListingViewModel)
    private var viewModel: MangasListingViewModel
    private let mangaGridsColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: mangaGridsColumns, spacing: 10) {
                    ForEach(self.viewModel.mangas) { manga in
                        CardView {
                            MangaCellView(manga: manga)
                        }
                        .onAppear {
                            self.viewModel.loadMoreIfNeeded(currentManga: manga)
                        }
                    }
                    .padding(5)
                    Divider().hidden()
                }
                .padding(.horizontal, 20)
            }
            .animation(.default, value: self.viewModel.mangas)
            .onFirstAppear {
                self.viewModel.onFirstAppear()
            }.refreshable {
                self.viewModel.reloadFromScratch()
            }
            .onEmpty(self.viewModel.showEmptyView) {
                EmptyListPlaceHolderView
                    .createSearchPlaceHolder(onRefresh: {
                        self.viewModel.reloadFromScratch()
                    })
            }
            ProgressView()
                .frame(width: UIScreen.width - 40, height: 30, alignment: .center)
                .isHidden(self.viewModel.hideBottomLoader, remove: self.viewModel.hideBottomLoader)
            Spacer()
        }
        .navigationTitle("Mangas")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Find Manga")
        .banner(params: $viewModel.banner)
    }
}

struct MangasListingView_Previews: PreviewProvider {
    static var previews: some View {
        MangasListingView()
    }
}
