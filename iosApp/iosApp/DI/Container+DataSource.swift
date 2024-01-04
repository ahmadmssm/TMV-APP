//
//  Container+DataSource.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Factory
import kmmSharedModule

extension Container {
    
    var mangasDataSource: Factory<MangasDataSource> {
        self {
            MangasDataSourceImpl(apiFactory: self.apiFactory(), localDatabase: self.mangaLocalDatabase(), networkUtils: self.networkUtils())
        }.singleton
    }
    
    var mangaChaptersDataSource: Factory<ChapterDataSource> {
        self {
            ChapterDataSourceImpl(apiFactory: self.apiFactory(), networkUtils: self.networkUtils())
        }.singleton
    }
    
    var mangaLocalDatabase: Factory<MangaLocalDatabase> {
        self {
            MangaLocalDatabaseImpl()
        }
    }
}
