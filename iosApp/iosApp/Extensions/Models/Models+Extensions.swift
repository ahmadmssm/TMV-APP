//
//  Models+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 20/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import kmmSharedModule

extension Manga: Diffable {
    
    func isTheSameAs(_ item: Manga) -> Bool {
        self.id == item.id
    }
}

extension Chapter: Diffable {
    
    func isTheSameAs(_ item: Chapter) -> Bool {
        self.id == item.id
    }
}
