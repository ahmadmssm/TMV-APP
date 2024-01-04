//
//  FavouriteMangasViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 08/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Combine
import kmmSharedModule

class FavouriteMangasViewModel: ObservableObject {
    
    private var isSearchMode = false
    private var disposeBag = Set<AnyCancellable>()
    private let mangasDataSource: MangasDataSource
    private lazy var listLoader = {
        ListLoader(listFetcher: { [weak self] in
            if let self {
                if self.isSearchMode {
                    self.mangasDataSource.fetchFavouriteMangas(searchTitle: self.searchText, successAction: $0, failureAction: $1)
                }
                else {
                    self.mangasDataSource.fetchFavouriteMangas(successAction: $0, failureAction: $1)
                }
            }
        }) { [weak self] in
            self?.mangas.append(contentsOf: $0)
        } showErrorAction: { [weak self] in
            self?.banner = .init(title: "Error", detail: $0, type: .error, isVisible: true)
        }.showLoadingAction {
            self.hideBottomLoader = false
        }.hideLoadingAction {
            self.hideBottomLoader = true
        }.shouldShowEmptyView {
            if self.isSearchMode {
                self.showEmptySearchView = $0
            }
            else {
                self.showEmptyView = $0
            }
        }
    }()
    //
    @Published var searchText: String = ""
    @Published var banner: BannerParams = .init(title: "", detail: "", type: .error, isVisible: false)
    @Published private(set) var mangas: [Manga] = []
    @Published private(set) var showEmptyView = false
    @Published private(set) var showEmptySearchView = false
    @Published private(set) var hideBottomLoader = true

    init(mangasDataSource: MangasDataSource) {
        self.mangasDataSource = mangasDataSource
        self.observeSearchBar()
    }
    
    func onAppear() {
        self.mangas.removeAll()
        self.listLoader.fetchItems()
    }
    
    func reloadFromScratch() {
        self.listLoader.reloadFromScratch(resetAction: {
            self.mangas.removeAll()
        })
    }
    
    private func observeSearchBar() {
        $searchText
             // Skip first
            .dropFirst()
             // 2 second debounce
            .debounce(for: 2, scheduler: RunLoop.main)
            // Equals to distinctUntilChanged
            // Ref: https://developer.apple.com/documentation/combine/publisher/removeduplicates()
            .removeDuplicates()
            // Called after 2 seconds when text stops updating (stoped typing)
            .sink { _ in
                self.performSearchIfNeeded()
            }
            .store(in: &disposeBag)
    }
    
    private func performSearchIfNeeded() {
        // Clear search field or pressed searchbar cancel button.
        // If was previously false, then do nothing, else reload from scratch.
        if self.searchText.trim().isEmpty, self.isSearchMode == true {
            self.isSearchMode = false
        }
        else {
            self.isSearchMode = true
        }
        self.reloadFromScratch()
    }
}
