package com.teavaro.kmmSharedModule.data.models.chapter

import kotlinx.serialization.Serializable

@Serializable
data class ChapterPagesInfo(val hash: String, val data: List<String>, val dataSaver: List<String>)