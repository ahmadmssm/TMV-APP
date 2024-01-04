package com.teavaro.kmmSharedModule.data.remote.rest

import com.teavaro.kmmSharedModule.data.remote.apis.APIs
import com.teavaro.kmmSharedModule.data.remote.rest.client.RestClient

class APIFactory(restClient: RestClient) {

    private val restClient = restClient.createClient()

    fun createAPIs(): APIs = this.restClient.create()
}