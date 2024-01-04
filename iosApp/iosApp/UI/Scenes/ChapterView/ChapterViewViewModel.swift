//
//  ChapterViewViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 09/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Factory
import kmmSharedModule

class ChapterViewViewModel: ObservableObject {

    @Published private(set) var chapterPagesURLs: [String] = []
    @Published var banner: BannerParams = .init(title: "", detail: "", type: .error, isVisible: false)
    
    private let chaptersDataSource: ChapterDataSource
        
    init(chaptersDataSource: ChapterDataSource) {
        self.chaptersDataSource = chaptersDataSource
    }
    
    func fetchChapterPages(chapterId: String) {
        self.chaptersDataSource.fetchChapterPages(chapterId: chapterId) { [weak self] in
            self?.chapterPagesURLs.append(contentsOf: $0.dataSaverPagesURLs)
        } failureAction: { [weak self] in
            self?.banner = .init(title: "Error", detail: $0, type: .error, isVisible: true)
        }
    }
}
