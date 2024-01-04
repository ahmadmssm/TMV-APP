//
//  TabbarControllerView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 19/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TabbarControllerView: View {
    
    @StateObject private var tabbarController = TabbarController()
    
    
    @State private var navigationId = UUID()
        
    var body: some View {
        // TabView(selection: tabbarController.selectedTabHandler) {
        TabView {
            TabbarItem(label: "Home", iconName: "house", index: 0) {
                MangasListingView()
            }
            TabbarItem(label: "Favourites", iconName: "heart.fill", index: 1) {
                FavouriteMangas()
            }
            TabbarItem(label: "For You", iconName: "menucard", index: 2) {
                EmptyListPlaceHolderView.createForYouPlaceHolder()
            }
            TabbarItem(label: "More", iconName: "ellipsis", index: 3) {
                MoreView()
            }
        }
    }
}

#Preview {
    TabbarControllerView()
}
