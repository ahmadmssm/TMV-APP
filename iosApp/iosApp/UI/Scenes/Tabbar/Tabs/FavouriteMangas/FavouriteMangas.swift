//
//  FavouriteMangas.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 08/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory

struct FavouriteMangas: View {
    
    @InjectedObject(\.favouriteMangasViewModel)
    private var viewModel: FavouriteMangasViewModel
    private let mangaGridsColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: mangaGridsColumns, spacing: 10) {
                        ForEach(self.viewModel.mangas) { manga in
                            CardView {
                                MangaCellView(manga: manga)
                            }
                            .onTapNavigate(to: MangaDetailsView(manga: manga))
                        }
                        .padding(5)
                        Divider().hidden()
                    }
                    .padding(.horizontal, 20)
                }
                .animation(.default, value: self.viewModel.mangas)
                .onAppear {
                    self.viewModel.onAppear()
                }
                .refreshable {
                    self.viewModel.reloadFromScratch()
                }
                .onEmpty(self.viewModel.showEmptyView) {
                    EmptyListPlaceHolderView
                        .createFavouritesPlaceHolder(onRefresh: {
                            self.viewModel.reloadFromScratch()
                        })
                        .onAppear {
                            self.viewModel.onAppear()
                        }
                }
                .onEmpty(self.viewModel.showEmptySearchView) {
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
            .navigationTitle("Favourite Mangas")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Find your favourite Manga")
        }
        .banner(params: $viewModel.banner)
    }
}

#Preview {
    FavouriteMangas()
}
