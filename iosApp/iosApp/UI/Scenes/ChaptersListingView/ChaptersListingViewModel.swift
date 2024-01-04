//
//  ChaptersListingViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 26/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Combine
import Factory
import kmmSharedModule

class ChaptersListingViewModel: ObservableObject {
    
    private var mangeId: String! {
        didSet {
            self.reloadFromScratch()
        }
    }
    private lazy var listLoader = {
        PagableListLoader(listFetcher: { self.chaptersDataSource.fetchMangaChapters(mangaId: self.mangeId, successAction: $0, failureAction: $1)}) { [weak self] in
            self?.chapters.append(contentsOf: $0)
        } showErrorAction: { [weak self] in
            self?.banner = .init(title: "Error", detail: $0, type: .error, isVisible: true)
        }.showLoadingAction {
            self.hideBottomLoader = false
        }.hideLoadingAction {
            self.hideBottomLoader = true
        }.noMoreItemsToLoadAction { [weak self] in
            self?.banner = .init(title: "No more chapters to load", detail: "", type: .info, isVisible: true)
        }
    }()
    private let chaptersDataSource: ChapterDataSource
    //
    @Published var banner: BannerParams = .init(title: "", detail: "", type: .error, isVisible: false)
    @Published private(set) var hideBottomLoader = true
    @Published private(set) var chapters: [Chapter] = []
    
    init(chaptersDataSource: ChapterDataSource) {
        self.chaptersDataSource = chaptersDataSource
    }
    
    func set(mangaId: String) {
        self.mangeId = mangaId
    }
    
    func reloadFromScratch() {
        self.listLoader.reloadFromScratch {
            self.chaptersDataSource.resetChaptersFetchingPagination()
            self.chapters.removeAll()
        }
    }
    
    func loadMoreIfNeeded(currentChapter: Chapter) {
        self.listLoader.loadMoreIfNeeded(item: currentChapter)
    }
}
