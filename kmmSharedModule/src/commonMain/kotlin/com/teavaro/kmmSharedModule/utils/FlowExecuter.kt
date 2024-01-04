package com.teavaro.kmmSharedModule.utils

import com.teavaro.kmmSharedModule.data.remote.rest.RestClientException
import com.teavaro.kmmSharedModule.utils.coroutinesDispatcher.CoroutinesDispatcher
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch

object FlowExecuter {

    private val ioDispatcher = CoroutinesDispatcher.io

    private fun mapThrowableToString(failureAction: (String) -> Unit): (Throwable) -> Unit {
        return { failureAction(it.stackTraceToString()) }
    }

    private fun mapThrowableToRestClientException(failureAction: (RestClientException) -> Unit): (Throwable) -> Unit {
        return { failureAction(RestClientException.fromThrowable(it)) }
    }

    private fun getUIScope(failure: (Throwable) -> Unit) = CoroutineScope(CoroutinesDispatcher.ui + CoroutineExceptionHandler { _, throwable ->
        CoroutineScope(CoroutinesDispatcher.ui).launch {
            failure(throwable)
        }
    })

    fun <T>executeApi(flow: Flow<T>, successAction: (T) -> Unit, failureAction: (RestClientException) -> Unit) {
        flow
            .flowOn(ioDispatcher)
            .catch {
                getUIScope(mapThrowableToRestClientException(failureAction)).launch {
                    failureAction(RestClientException.fromThrowable(it))
                }
            }
            .onEach {
                getUIScope(mapThrowableToRestClientException(failureAction)).launch {
                    successAction(it)
                }
            }
            .launchIn(getUIScope(mapThrowableToRestClientException(failureAction)))
    }

    fun <T>execute(flow: Flow<T>, successAction: (T) -> Unit, failureAction: (String) -> Unit) {
        flow
            .flowOn(ioDispatcher)
            .catch {
                getUIScope(mapThrowableToString(failureAction)).launch {
                    failureAction(it.stackTraceToString())
                }
            }
            .onEach {
                getUIScope(mapThrowableToString(failureAction)).launch {
                    successAction(it)
                }
            }
            .launchIn(getUIScope(mapThrowableToString(failureAction)))
    }
}