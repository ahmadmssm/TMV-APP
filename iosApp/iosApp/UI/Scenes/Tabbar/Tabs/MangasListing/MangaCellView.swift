//
//  MangaCellView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 19/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import NukeUI
import SwiftUI
import kmmSharedModule

struct MangaCellView: View {
        
    private(set) var manga: Manga
    
    var body: some View {
        VStack {
            Image.fullSizeImageView(url: manga.coverImageURL ?? "")
            Text(manga.attributes.englishTitle ?? "N/A")
                .padding(.bottom, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .font(.system(size: 14))
        }
        .onTapNavigate(to: MangaDetailsView(manga: manga))
    }
}

struct MangaCellView_Previews: PreviewProvider {
    static var previews: some View {
        MangasListingView()
    }
}
