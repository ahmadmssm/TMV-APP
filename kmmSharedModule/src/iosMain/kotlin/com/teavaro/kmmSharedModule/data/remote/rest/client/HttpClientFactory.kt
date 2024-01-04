package com.teavaro.kmmSharedModule.data.remote.rest.client

import com.teavaro.kmmSharedModule.BuildKonfig
import com.teavaro.kmmSharedModule.data.remote.rest.PlatformType
import com.teavaro.kmmSharedModule.utils.logger.SystemLogger
import io.ktor.client.engine.darwin.Darwin

actual class HttpClientFactory(private val logger: SystemLogger) {

    fun create(): RestClient {
        val baseURL = BuildKonfig.baseURL
        val engine = Darwin.create()
        return RestClientImpl(baseURL, engine, PlatformType.IOS, logger)
    }
}