package com.teavaro.kmmSharedModule.utils.logger

actual interface SystemLogger {
    actual fun prettyPrint(string: String)
    actual fun log(string: String)
    fun log(tag: String, string: String)
}