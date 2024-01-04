//
//  InfoPlistReader.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

struct InfoPlistReader {
    
    private let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    func value<T>(for key: String) throws -> T {
        let capitalizedKeyDescription = key.prefix(1).capitalized + key.dropFirst()
        guard let object = self.bundle.object(forInfoDictionaryKey: capitalizedKeyDescription) else {
            throw Error.missingKey("Key \(capitalizedKeyDescription) is not founded")
        }
        guard let value = object as? T else {
            throw Error.invalidValue
        }
        return value
    }
}

private extension InfoPlistReader {
    
    enum Error: Swift.Error {
        case missingPlistFile, missingKey(_ message: String), invalidValue
    }
}
