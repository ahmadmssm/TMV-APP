//
//  GlobalBottomSheetController.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 08/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

class GlobalBottomSheetController: ObservableObject {
    
    @Published var isPresented: Bool = false
    private(set) var message: String = ""
    
    func post(message: String) {
        if !message.isEmpty {
            self.message = message
            self.isPresented = true
        }
    }
}
