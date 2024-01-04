package com.teavaro.kmmSharedModule.utils.logger

expect interface SystemLogger {
    fun log(string: String)
    fun prettyPrint(string: String)
}