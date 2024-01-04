package com.teavaro.kmmSharedModule.data.remote.rest.response.wrappers

import kotlinx.serialization.Serializable

@Serializable
data class ResponsePayload<out T>(val statusCode: Int, val headers: Map<String, String>, val data: T)