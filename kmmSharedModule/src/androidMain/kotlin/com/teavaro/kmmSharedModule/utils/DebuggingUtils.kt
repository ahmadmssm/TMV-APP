package com.teavaro.kmmSharedModule.utils

import android.content.Context
import com.chuckerteam.chucker.api.ChuckerInterceptor
import io.ktor.client.engine.okhttp.*
import okhttp3.logging.HttpLoggingInterceptor

object DebuggingUtils {

    internal fun addDebuggingInterceptors(context: Context, okHttpConfig: OkHttpConfig) {
        val chuckerInterceptor = ChuckerInterceptor.Builder(context)
            .redactHeaders("Authorization", "Bearer")
            // Read the whole response body even when the client does not consume the response completely.
            // This is useful in case of parsing errors or when the response body
            // is closed before being read like in Retrofit with Void and Unit types.
            .alwaysReadResponseBody(true)
            .build()
        val httpLoggingInterceptor = HttpLoggingInterceptor().apply {
            redactHeader("Authorization")
            redactHeader("Bearer")
            setLevel(HttpLoggingInterceptor.Level.BODY)
        }
        okHttpConfig.apply {
            addInterceptor(chuckerInterceptor)
            addInterceptor(httpLoggingInterceptor)
        }
    }
}
