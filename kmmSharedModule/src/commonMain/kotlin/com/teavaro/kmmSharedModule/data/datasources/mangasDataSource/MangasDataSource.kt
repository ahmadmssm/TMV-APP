package com.teavaro.kmmSharedModule.data.datasources.mangasDataSource

import com.teavaro.kmmSharedModule.data.models.manga.Manga

interface MangasDataSource {
    fun fetchMangas(successAction: (isLastPage: Boolean, List<Manga>) -> Unit, failureAction: (String) -> Unit)
    fun fetchMangas(searchTitle: String, successAction: (isLastPage: Boolean, List<Manga>) -> Unit, failureAction: (String) -> Unit)
    fun fetchFavouriteMangas(successAction: (List<Manga>) -> Unit, failureAction: (String) -> Unit)
    fun fetchFavouriteMangas(searchTitle: String, successAction: (List<Manga>) -> Unit, failureAction: (String) -> Unit)
    fun findFavouriteManga(mangaId: String): Manga?
    fun resetPagination()
    fun addMangaToFavourite(manga: Manga, successAction: () -> Unit, failureAction: (String) -> Unit)
    fun deleteFavouriteManga(manga: Manga, successAction: () -> Unit, failureAction: (String) -> Unit)
}

