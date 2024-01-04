package com.teavaro.kmmSharedModule.data.models.manga

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class MangaAttributes(val title: Map<String, String>,
                           val altTitles: List<Map<String, String>>?,
                           val description: Map<String, String>,
                           val links: Map<String, String>?,
                           val lastVolume: String?,
                           val lastChapter: String?,
                           val year: Int?,
                           val contentRating: String,
                           val version: Int,
                           @SerialName("latestUploadedChapter")
                           val latestChapterId: String?) {
    val originalURL = links?.get("engtl")
    val englishTitle = title["en"]
    val englishSummary = description["en"]
}