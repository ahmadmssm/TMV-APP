package com.teavaro.kmmSharedModule.data.models

import com.teavaro.kmmSharedModule.data.models.manga.Manga
import kotlinx.serialization.Serializable
import kotlin.math.ceil

@Serializable
data class Page<T>(val data: List<T>, val limit: Int, val offset: Int, val total: Int) {
    val pages = ceil(total.div(limit.toDouble())).toInt()
    /*
     We should start from page zero but we are adding the 1 here instead of
     adding it to the next offset equation se the page count starts from 1 to the last page instead off 0 the last page - 1
     */
    val currentPage get() = (offset.div(limit)) + 1
    // If we started from currentPage 0, then the equation should be (currentPage + 1) * limit
    val nextOffset get() = if(isLastPage) offset else currentPage * limit
    // If we started from currentPage 0, then the equation should be currentPage == (pages - 1)
    val isLastPage get() = currentPage == pages
}