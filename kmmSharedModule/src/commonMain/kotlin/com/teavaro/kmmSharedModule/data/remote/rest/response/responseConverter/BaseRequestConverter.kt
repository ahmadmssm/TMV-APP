package com.teavaro.kmmSharedModule.data.remote.rest.response.responseConverter

import de.jensklingenberg.ktorfit.converter.Converter
import io.ktor.client.call.save
import io.ktor.client.plugins.ClientRequestException
import io.ktor.client.plugins.RedirectResponseException
import io.ktor.client.plugins.ResponseException
import io.ktor.client.plugins.ServerResponseException
import io.ktor.client.statement.HttpResponse
import io.ktor.client.statement.bodyAsText
import io.ktor.client.statement.request
import io.ktor.http.setCookie
import io.ktor.util.toMap
import io.ktor.utils.io.charsets.MalformedInputException

internal open class BaseRequestConverter: Converter.Factory {

    protected suspend fun <T>createResponseOrThrow(response: HttpResponse,
                                                   success: suspend (headers: Map<String, String>, statusCode: Int) -> T,
                                                   failure: suspend (ResponseException) -> T): T {
        val statusCode = response.status.value
        if (statusCode < 300) {
            val headers = response.headers.toMap().filterValues { it.isNotEmpty() }.mapValues { it.value.first() }
            return success(headers, statusCode)
        }
        else {
            val exceptionResponse = response.call.save().response
            val exceptionResponseText = try { exceptionResponse.bodyAsText() } catch (e: MalformedInputException) { e.message ?: e.stackTraceToString() }
            val exception = when (statusCode) {
                in 300..399 -> RedirectResponseException(exceptionResponse, exceptionResponseText)
                in 400..499 -> ClientRequestException(exceptionResponse, exceptionResponseText)
                in 500..599 -> ServerResponseException(exceptionResponse, exceptionResponseText)
                else -> ResponseException(exceptionResponse, exceptionResponseText)
            }
            return failure(exception)
        }
    }
}