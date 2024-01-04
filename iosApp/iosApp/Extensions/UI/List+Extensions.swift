//
//  List+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 16/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

extension List {
    func removeTopPadding() -> some View {
        padding(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0))
    }
}
