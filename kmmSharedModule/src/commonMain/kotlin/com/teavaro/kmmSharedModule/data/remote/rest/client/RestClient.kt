package com.teavaro.kmmSharedModule.data.remote.rest.client

import de.jensklingenberg.ktorfit.Ktorfit

interface RestClient {
    fun createClient(): Ktorfit
}