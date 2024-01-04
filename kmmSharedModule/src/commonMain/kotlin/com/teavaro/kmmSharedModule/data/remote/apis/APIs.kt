package com.teavaro.kmmSharedModule.data.remote.apis

import com.teavaro.kmmSharedModule.data.models.Page
import com.teavaro.kmmSharedModule.data.models.chapter.Chapter
import com.teavaro.kmmSharedModule.data.models.chapter.ChapterPages
import com.teavaro.kmmSharedModule.data.models.manga.Manga
import de.jensklingenberg.ktorfit.http.GET
import de.jensklingenberg.ktorfit.http.Path
import de.jensklingenberg.ktorfit.http.Query
import kotlinx.coroutines.flow.Flow

interface APIs {

    // Default: "order[latestUploadedChapter]=desc"
    // order[createdAt]=desc
    @GET("manga?includes[]=cover_art&includes[]=author&hasAvailableChapters=true&contentRating[]=safe")
    fun fetchMangas(@Query("offset") offset: Int,
                    @Query("limit") perPage: Int = 20,
                    @Query("title") title: String? = null): Flow<Page<Manga>>

    @GET("manga/{manga_id}/feed?order[chapter]=desc&includeEmptyPages=0&includeEmptyPages=0")
    fun fetchChapters(@Path("manga_id") mangaId: String,
                      @Query("offset") offset: Int,
                      @Query("limit") perPage: Int = 20): Flow<Page<Chapter>>

    @GET("/at-home/server/{chapter_id}")
    fun fetchChapterPages(@Path("chapter_id") chapterId: String): Flow<ChapterPages>
}