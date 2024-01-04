//
//  Diffable.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 29/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

protocol Diffable: Identifiable, Equatable {
    func isTheSameAs(_ item: Self) -> Bool
}
