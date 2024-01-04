//
//  InfoPlistVariable.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

@propertyWrapper
struct InfoPlistVariable<T> {

    private let key: String
    private let infoPlistReader: InfoPlistReader

    var wrappedValue: T {
        try! self.infoPlistReader.value(for: key)
    }
    
    init(key: String, bundle: Bundle = .main) {
        self.key = key
        self.infoPlistReader = InfoPlistReader(bundle: bundle)
    }
    
    init<E: RawRepresentable>(key: E, bundle: Bundle = .main) where E.RawValue == String {
        self.key = key.rawValue
        self.infoPlistReader = InfoPlistReader(bundle: bundle)
    }
}
