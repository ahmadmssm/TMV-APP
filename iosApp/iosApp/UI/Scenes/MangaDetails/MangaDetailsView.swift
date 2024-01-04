//
//  MangaDetailsView.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 22/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Factory
import kmmSharedModule

struct MangaDetailsView: View {
    
    @InjectedObject(\.mangaDetailsViewModel)
    private var viewModel: MangaDetailsViewModel
    private(set) var manga: Manga
    
    var body: some View {
        ScrollView {
            VStack {
                Image.fullSizeImageView(url: self.manga.coverImageURL ?? "")
                Spacer(minLength: 20)
                //
                self.viewModel.isFavourite ? self.createFavouriteLabel(text: "Remove from favourites", iconName: "heart.fill") : self.createFavouriteLabel(text: "Add to favourites", iconName: "heart")
                Spacer(minLength: 20)
                if let latestChapterId = self.manga.attributes.latestChapterId {
                    self.createViewLatestChapterButton(latestChapterId)
                    Spacer(minLength: 10)
                }
                self.createAllChaptersButton()
                Spacer(minLength: 25)
                Group {
                    Text(self.createLabeledAttributedString("Year: ", self.manga.attributes.year?.stringValue ?? "N/A"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    if let text = self.manga.attributes.lastChapter, !text.isEmpty {
                        Text(self.createLabeledAttributedString("Last Chapter: ", text))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                Text(self.createLabeledAttributedString("Content Rating: ", self.manga.attributes.contentRating.capitalized))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Spacer()
                Text(self.createLabeledAttributedString("Author: ", self.manga.author ?? "N/A"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Spacer()
                Text("Summary:")
                    .padding(.leading)
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Group {
                    let text = if let text = self.manga.attributes.englishSummary, !text.isEmpty {
                        text
                    } else {
                        "N/A"
                    }
                    Text(text)
                        .padding(.leading)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer(minLength: 25)
            }
        }
        .navigationTitle(self.manga.attributes.englishTitle ?? "")
        .onAppear {
            self.viewModel.checkIfFavourite(mangaId: manga.id)
        }
    }
    
    private func createFavouriteLabel(text: String, iconName: String) -> some View {
        let icon = Image(systemName: iconName)
            .foregroundColor(.red)
        return Label(title: {
            Text(text)
        }, icon: {
            icon
        })
        .foregroundColor(.red)
        .frame(width: UIScreen.width, height: 40, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.red, lineWidth: 1)
                .background(Color.white.cornerRadius(10))
                .padding(.leading)
                .padding(.trailing)
        ).onTapGesture {
            self.viewModel.addOrRemoveFavourite(manga: self.manga)
        }
    }
    
    private func createLabelAttributedString(string: String) -> AttributedString {
        var result = AttributedString(string)
        result.font = .title3
        result.foregroundColor = .blue
        return result
    }
    
    private func createLabelValueAttributedString(string: String) -> AttributedString {
        var result = AttributedString(string)
        result.font = .body
        result.foregroundColor = .black
        return result
    }
    
    private func createLabeledAttributedString(_ labelName: String, _ labelValue: String) -> AttributedString {
        self.createLabelAttributedString(string: labelName) + self.createLabelValueAttributedString(string: labelValue)
    }
    
    private func createViewLatestChapterButton(_ latestChapterId: String) -> some View {
        Text("View latest chapter")
            .foregroundColor(.white)
            .frame(width: UIScreen.width, height: 40, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.green, lineWidth: 1)
                    .background(Color.green.cornerRadius(10))
                    .padding(.leading)
                    .padding(.trailing)
            )
            .onTapNavigate(to: ChapterView(chapterId: latestChapterId, externalUrl: nil, chapterNumber: self.manga.attributes.lastChapter))
    }
    
    private func createAllChaptersButton() -> some View {
        Text("All chapters")
            .foregroundColor(.white)
            .frame(width: UIScreen.width, height: 40, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue, lineWidth: 1)
                    .background(Color.blue.cornerRadius(10))
                    .padding(.leading)
                    .padding(.trailing)
            )
            .onTapNavigate(to: ChaptersListingView(mangaId:  self.manga.id, mangaName: manga.attributes.englishTitle ?? "N/A"))
    }
}

#Preview {
    MangaDetailsView(manga: Manga.companion.createDummyManga())
}
