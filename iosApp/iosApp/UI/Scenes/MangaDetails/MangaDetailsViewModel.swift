//
//  MangaDetailsViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 13/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import kmmSharedModule

class MangaDetailsViewModel: ObservableObject {

    @Published private(set) var isFavourite = false
    @Published var banner: BannerParams = .init(title: "", detail: "", type: .error, isVisible: false)
    //
    private let mangasDataSource: MangasDataSource
    
    init(mangasDataSource: MangasDataSource) {
        self.mangasDataSource = mangasDataSource
    }
    
    func checkIfFavourite(mangaId: String) {
        self.isFavourite = self.mangasDataSource.findFavouriteManga(mangaId: mangaId) != nil
    }
    
    func addOrRemoveFavourite(manga: Manga) {
        if self.isFavourite {
            self.removeFavouriteManga(manga: manga)
        }
        else {
            self.addMangaToFavourites(manga: manga)
        }
    }
    
    private func addMangaToFavourites(manga: Manga) {
        self.mangasDataSource.addMangaToFavourite(manga: manga) { [weak self] in
            self?.isFavourite = true
        } failureAction: { [weak self] in
            self?.banner = .init(title: "Error", detail: $0, type: .error, isVisible: true)
        }
    }
    
    private func removeFavouriteManga(manga: Manga) {
        self.mangasDataSource.deleteFavouriteManga(manga: manga) { [weak self] in
            self?.isFavourite = false
        } failureAction: { [weak self] in
            self?.banner = .init(title: "Error", detail: $0, type: .error, isVisible: true)
        }
    }
}
