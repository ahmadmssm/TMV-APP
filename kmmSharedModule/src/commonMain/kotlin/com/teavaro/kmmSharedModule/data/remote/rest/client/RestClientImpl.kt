package com.teavaro.kmmSharedModule.data.remote.rest.client

import com.teavaro.kmmSharedModule.data.remote.rest.PlatformType
import com.teavaro.kmmSharedModule.utils.logger.SystemLogger
import de.jensklingenberg.ktorfit.Ktorfit
import io.ktor.client.*
import io.ktor.client.engine.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json

class RestClientImpl(baseURL: String,
                     private val httpClientEngine: HttpClientEngine,
                     private val platformType: PlatformType,
                     private val logger: SystemLogger): RestClient {

    private companion object {
        private const val REQUEST_TIMEOUT_INTERVAL = 60000   // Milliseconds
    }

    private val client by lazy {
        Ktorfit.Builder()
            .baseUrl(baseURL)
            .converterFactories(FlowConverterFactory())
            .httpClient(ktorHttpClient)
            .build()
    }

    @OptIn(ExperimentalSerializationApi::class)
    private val ktorHttpClient by lazy {
        // https://ktor.io/docs/http-client-engines.html#default
        HttpClient(engine = httpClientEngine) {

            install(HttpTimeout) {
                requestTimeoutMillis = REQUEST_TIMEOUT_INTERVAL.toLong()
            }

            install(ContentNegotiation) {
                json(Json {
                    prettyPrint = true
                    isLenient = true
                    explicitNulls = false
                    ignoreUnknownKeys = true
                })
            }

            // For Android we will ues OkHttp logger (OkHttpLoggingInterceptor) and for iOS we will use Ktor default logger.
            if (platformType == PlatformType.IOS)
                install(Logging) {
                    logger = object : Logger {
                        override fun log(message: String) {
                          this@RestClientImpl.logger.prettyPrint(message)
                        }
                    }
                    level = LogLevel.ALL
                }

            engine {
                // this: HttpClientEngineConfig
                threadsCount = 4
                pipelining = true
            }
        }
    }

    override fun createClient() = this.client
}