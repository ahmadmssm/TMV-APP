package com.teavaro.kmmSharedModule.data.models.chapter

import kotlinx.serialization.Serializable

@Serializable
data class Chapter(val id: String, val attributes: ChapterAttributes)