//
//  ChaptersListingRowView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 27/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct ChaptersListingRowView: View {

    var chapterPages: Int32
    var publishAt: String
    var chapterNumber: String
    var chapterLanguage: String

    var body: some View {
        VStack {
            Spacer()
            Text(publishAt)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            Spacer()
            HStack {
                Text("Chapter \(self.chapterNumber)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                Text("\(self.chapterPages) pages")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10)
            }
            Spacer()
            Text("Language \(self.chapterLanguage.capitalized)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            Spacer()
        }
    }
}

#Preview {
    ChaptersListingRowView(chapterPages: 25, publishAt: "23/06/2023", chapterNumber: "12", chapterLanguage: "En")
}
