//
//  UIScreen+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 21/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let rectSize = UIScreen.main.bounds.size
    static var aspectRatio = height / width
}
