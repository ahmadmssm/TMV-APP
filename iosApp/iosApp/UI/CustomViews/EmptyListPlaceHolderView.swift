//
//  EmptyListPlaceHolderView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct EmptyListPlaceHolderView: View {
    
    private var iconName: String
    private var title: String
    private var subTitle: String
    private var refreshAction: (() -> ())?
    
    var body: some View {
        VStack {
            if let image = UIImage(systemName: self.iconName) {
                Image.init(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            else {
                Image(self.iconName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            Text(self.title)
                .font(.system(size: 20, weight: .heavy))
                .padding(.top, 5)
                .padding(.bottom, 5)
            Text(self.subTitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom, 5)
            if self.refreshAction != nil {
                Text("Refresh")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        refreshAction!()
                    }
            }
        }
    }
}

extension EmptyListPlaceHolderView {
    
    static func createSearchPlaceHolder(onRefresh: (() -> ())? = nil) -> some View {
        EmptyListPlaceHolderView(iconName: "magnifyingglass",
                                 title: "No Results",
                                 subTitle: "Please check the spelling or try a new search.",
                                 refreshAction: onRefresh)
    }
    
    static func createFavouritesPlaceHolder(onRefresh: (() -> ())? = nil) -> some View {
        EmptyListPlaceHolderView(iconName: "love",
                                 title: "No Favourites",
                                 subTitle: "Please add a favourite Manga.",
                                 refreshAction: onRefresh)
    }
    
    static func createForYouPlaceHolder(onRefresh: (() -> ())? = nil) -> some View {
        EmptyListPlaceHolderView(iconName: "empty_folder",
                                 title: "No Recommendations yet",
                                 subTitle: "We recommend Mangas based on your favourites, please add some favorties, so we can recommend some Mangas to you.",
                                 refreshAction: onRefresh)
    }
}

#Preview {
    EmptyListPlaceHolderView.createSearchPlaceHolder(onRefresh: {})
}
