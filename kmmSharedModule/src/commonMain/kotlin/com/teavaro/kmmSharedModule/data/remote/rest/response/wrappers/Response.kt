package com.teavaro.kmmSharedModule.data.remote.rest.response.wrappers

import com.teavaro.kmmSharedModule.data.remote.rest.RestClientException

sealed interface Response<T> {
    data class Success<T>(val statusCode: Int, val headers: Map<String, String>, val data: T):
        Response<T>
    class Failure<T>(val e: RestClientException): Response<T>
}