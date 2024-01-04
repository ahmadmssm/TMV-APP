//
//  Prefixes.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

// Ref: https://stackoverflow.com/a/61733134/6927433
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
