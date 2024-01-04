package com.teavaro.kmmSharedModule.utils.logger

actual interface SystemLogger {
    actual fun log(string: String)
    actual fun prettyPrint(string: String)
    fun info(string: String)
    fun info(tag: String, string: String)
    fun debug(string: String)
    fun debug(tag: String, string: String)
}