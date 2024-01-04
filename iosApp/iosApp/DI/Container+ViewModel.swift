//
//  Container+ViewModel.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Factory
import kmmSharedModule

extension Container {
    
    var contentViewViewModel: Factory<ContentViewViewModel> {
        self {
            ContentViewViewModel(localStorage: self.localStorage(), sdksManagerProxy: self.sdksManagerProxy())
        }
    }
    
    var mangasListingViewModel: Factory<MangasListingViewModel> {
        self {
            MangasListingViewModel(mangasDataSource: self.mangasDataSource())
        }
    }
    
    var teavaroConsentViewViewModel: Factory<TeavaroConsentViewViewModel> {
        self {
            TeavaroConsentViewViewModel(localStorage: self.localStorage(), sdksManager: self.sdksManagerProxy(), globalBottomSheetController: self.globalBottomSheetController())
        }
    }
    
    var utiqConsentViewViewModel: Factory<UTIQConsentViewViewModel> {
        self {
            UTIQConsentViewViewModel(sdksManager: self.sdksManagerProxy(), localStorage: self.localStorage(), globalBottomSheetController: self.globalBottomSheetController())
        }
    }
    
    var favouriteMangasViewModel: Factory<FavouriteMangasViewModel> {
        self {
            FavouriteMangasViewModel(mangasDataSource: self.mangasDataSource())
        }
    }
    
    var moreViewModel: Factory<MoreViewModel> {
        self {
            MoreViewModel(localStorage: self.localStorage(), sdksManagerProxy: self.sdksManagerProxy())
        }
    }
    
    var mangaDetailsViewModel: Factory<MangaDetailsViewModel> {
        self {
            MangaDetailsViewModel(mangasDataSource: self.mangasDataSource())
        }
    }
    
    var chaptersListingViewModel: Factory<ChaptersListingViewModel> {
        self {
            ChaptersListingViewModel(chaptersDataSource: self.mangaChaptersDataSource())
        }
    }
    
    var chapterViewViewModel: Factory<ChapterViewViewModel> {
        self {
            ChapterViewViewModel(chaptersDataSource: self.mangaChaptersDataSource())
        }
    }
}
