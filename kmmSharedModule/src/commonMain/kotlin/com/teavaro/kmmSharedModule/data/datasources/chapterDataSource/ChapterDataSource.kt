package com.teavaro.kmmSharedModule.data.datasources.chapterDataSource

import com.teavaro.kmmSharedModule.data.models.chapter.Chapter
import com.teavaro.kmmSharedModule.data.models.chapter.ChapterPages

interface ChapterDataSource {
    fun fetchMangaChapters(mangaId: String, successAction: (isLastPage: Boolean, List<Chapter>) -> Unit, failureAction: (String) -> Unit)
    fun fetchChapterPages(chapterId: String, successAction: (ChapterPages) -> Unit, failureAction: (String) -> Unit)
    fun resetChaptersFetchingPagination()
}