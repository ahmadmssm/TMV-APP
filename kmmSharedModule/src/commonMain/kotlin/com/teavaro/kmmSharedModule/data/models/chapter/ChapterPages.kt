package com.teavaro.kmmSharedModule.data.models.chapter

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ChapterPages(val baseUrl: String, @SerialName("chapter") val pagesInfo: ChapterPagesInfo) {
    val pagesURLs get() = pagesInfo.data.map { "${this.baseUrl}/data/${pagesInfo.hash}/$it" }
    val dataSaverPagesURLs get() = pagesInfo.dataSaver.map { "${this.baseUrl}/data-saver/${pagesInfo.hash}/$it" }
}