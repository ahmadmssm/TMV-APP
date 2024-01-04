//
//  MangasListingViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 18/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Combine
import Factory
import kmmSharedModule

class MangasListingViewModel: ObservableObject {
    
    private var isSearchMode = false
    private var disposeBag = Set<AnyCancellable>()
    private lazy var listLoader = {
        PagableListLoader(listFetcher: {
            if self.isSearchMode {
                self.mangasDataSource.fetchMangas(searchTitle: self.searchText, successAction: $0, failureAction: $1)
            }
            else {
                self.mangasDataSource.fetchMangas(successAction: $0, failureAction: $1)
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
            self.showEmptyView = $0
        }.noMoreItemsToLoadAction { [weak self] in
            self?.banner = .init(title: "", detail: "No more Mangas to load", type: .info, isVisible: true)
        }
    }()
    private let mangasDataSource: MangasDataSource
    //
    @Published var searchText: String = ""
    @Published var banner: BannerParams = .init(title: "", detail: "", type: .error, isVisible: false)
    @Published private(set) var mangas: [Manga] = []
    @Published private(set) var showEmptyView = false
    @Published private(set) var hideBottomLoader = true

    init(mangasDataSource: MangasDataSource) {
        self.mangasDataSource = mangasDataSource
        self.observeSearchBar()
    }
    
    func onFirstAppear() {
        self.listLoader.fetchItems()
    }
    
    func loadMoreIfNeeded(currentManga: Manga) {
        self.listLoader.loadMoreIfNeeded(item: currentManga)
    }
    
    func reloadFromScratch() {
        self.listLoader.reloadFromScratch(resetPaginationAction: {
            self.mangasDataSource.resetPagination()
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
