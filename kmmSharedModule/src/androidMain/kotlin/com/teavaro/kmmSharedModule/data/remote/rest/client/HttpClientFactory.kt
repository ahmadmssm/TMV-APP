package com.teavaro.kmmSharedModule.data.remote.rest.client

import android.content.Context
import com.teavaro.kmmSharedModule.BuildKonfig
import com.teavaro.kmmSharedModule.data.remote.rest.PlatformType
import com.teavaro.kmmSharedModule.utils.DebuggingUtils
import com.teavaro.kmmSharedModule.utils.logger.SystemLogger
import io.ktor.client.engine.okhttp.OkHttp

actual class HttpClientFactory(private val context: Context,
                               private val logger: SystemLogger) {

    fun create(enableLogging: Boolean): RestClient {
        val baseURL = BuildKonfig.baseURL
        val engine = OkHttp.create {
            if (enableLogging) {
                DebuggingUtils.addDebuggingInterceptors(context, this)
            }
        }
        return RestClientImpl(baseURL, engine, PlatformType.ANDROID, logger)
    }
}