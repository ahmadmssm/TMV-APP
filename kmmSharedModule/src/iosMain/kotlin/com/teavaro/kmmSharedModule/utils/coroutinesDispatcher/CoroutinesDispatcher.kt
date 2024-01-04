package com.teavaro.kmmSharedModule.utils.coroutinesDispatcher

import kotlinx.coroutines.Dispatchers
import kotlin.coroutines.CoroutineContext

actual object CoroutinesDispatcher {
    actual val ui: CoroutineContext = Dispatchers.Main
    actual val io: CoroutineContext = NSLooperDispatcher
    actual val default: CoroutineContext = Dispatchers.Default
}