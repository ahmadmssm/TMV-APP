package com.teavaro.kmmSharedModule.data.models.chapter

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ChapterAttributes(val title: String?,
                             val pages: Int,
                             val externalUrl: String?,
                             val readableAt: String,
                             val publishAt: String,
                             @SerialName("translatedLanguage")
                             val language: String?,
                             @SerialName("chapter")
                             val chapterNumber: String?)  {
    val formattedPublishAt get() = DateTimeUtils.format(publishAt)
}