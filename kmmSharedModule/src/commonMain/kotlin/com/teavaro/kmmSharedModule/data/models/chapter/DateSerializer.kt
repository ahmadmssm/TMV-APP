package com.teavaro.kmmSharedModule.data.models.chapter

import com.teavaro.kmmSharedModule.utils.extensions.zeroPrefixed
import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime

internal object DateTimeUtils {

    fun format(timestamp: String): String {
        val date = Instant.parse(timestamp).toLocalDateTime(TimeZone.currentSystemDefault())
        val day = date.dayOfMonth
        val month = date.monthNumber
        val year = date.year
        return "${day.zeroPrefixed(2)}.${month.zeroPrefixed(2)}.${year}"
    }
}