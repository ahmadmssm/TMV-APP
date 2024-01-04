package com.teavaro.kmmSharedModule.utils

import kotlinx.serialization.*
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject

object Serializer {

    inline fun <reified T> objectToString(obj: T): String {
        return Json.encodeToString(obj)
    }

    // The T class must be annotated with [Serializable] or be one of the built-in types.
    @OptIn(ExperimentalSerializationApi::class)
    @Throws(Exception::class)
    inline fun <reified T> objectFromString(string: String): T {
        // https://github.com/Kotlin/kotlinx.serialization/blob/master/docs/json.md#ignoring-unknown-keys
        val format = Json {
            explicitNulls = false
            ignoreUnknownKeys = true
        }
        return format.decodeFromString(string)
    }

    fun mapFromString(string: String) = Json.parseToJsonElement(string).jsonObject.toMap()
}