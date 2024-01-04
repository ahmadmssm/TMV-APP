package com.teavaro.kmmSharedModule.data.remote.rest

import io.ktor.client.plugins.*
import io.ktor.util.flattenEntries

sealed class RestClientException(val errorMessage: String): Exception(errorMessage) {

    class HttpError(val statusCode: Int, val headers: Map<String, String>, errorMessage: String): RestClientException(errorMessage)
    class GenericError(errorMessage: String): RestClientException(errorMessage)

    companion object {

        private fun fromException(exception: Exception): RestClientException =
            when (exception) {
                is ServerResponseException ->
                    HttpError(exception.response.status.value, exception.response.headers.flattenEntries().toMap(), exception.message)
                is RedirectResponseException ->
                    HttpError(exception.response.status.value, exception.response.headers.flattenEntries().toMap(), exception.message)
                is ClientRequestException ->
                    HttpError(exception.response.status.value, exception.response.headers.flattenEntries().toMap(), exception.message)
                else ->
                    GenericError(exception.message ?: exception.cause?.message ?: exception.stackTraceToString())
            }

        fun fromThrowable(throwable: Throwable): RestClientException {
            return when (throwable) {
                is RestClientException ->
                    throwable
                is Exception ->
                    fromException(throwable)
                else ->
                    GenericError(throwable.message ?: throwable.stackTraceToString())
            }
        }
    }
}