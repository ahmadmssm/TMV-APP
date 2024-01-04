package com.teavaro.kmmSharedModule.utils.coroutinesDispatcher

import kotlin.coroutines.CoroutineContext

expect object CoroutinesDispatcher {
    val ui: CoroutineContext
    val io: CoroutineContext
    val default: CoroutineContext
}