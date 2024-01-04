//
//  CGFloat+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 02/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

extension CGFloat {
    
    func round(to decimalPlaces: Int) -> CGFloat {
        let precisionNumber = pow(10, Double(decimalPlaces))
        var n = self
        n = n * precisionNumber
        n.round()
        n = n / precisionNumber
        return n
    }
}

