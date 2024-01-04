//
//  IndexedForEach.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 19/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct IndexedForEach<ItemType, ContentView: View>: View {
  
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView

    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }

    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.0) { idx, item in
            content(idx, item)
        }
    }
}
