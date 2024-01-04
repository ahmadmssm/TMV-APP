package com.teavaro.kmmSharedModule.utils.logger

import android.util.Log

actual class LoggerImpl actual constructor(private val enableLogging: Boolean): SystemLogger {

    @Suppress("PrivatePropertyName")
    private val TAG = "Teavaro SDK "

    override fun log(string: String) {
        if (enableLogging)
            Log.v(TAG, string)
    }

    override fun info(string: String) {
        if (enableLogging)
            this.logLongString(string) {
                Log.i(TAG, it)
            }
    }

    override fun info(tag: String, string: String) {
        if (enableLogging)
            this.logLongString(string) {
                Log.i(tag, it)
            }
    }

    override fun debug(string: String) {
        if (enableLogging)
            this.logLongString(string) {
                Log.d(TAG, it)
            }
    }

    override fun debug(tag: String, string: String) {
        if (enableLogging)
            this.logLongString(string) {
                Log.d(tag, it)
            }
    }

    override fun prettyPrint(string: String) {
        if (enableLogging) {
            var indentLevel = 0
            val indentWidth = 4
            fun padding() = "".padStart(indentLevel * indentWidth)
            val stringBuilder = StringBuilder(string.length)
            var i = 0
            while (i < string.length) {
                when (val char = string[i]) {
                    '(', '[', '{' -> {
                        indentLevel++
                        stringBuilder.appendLine(char).append(padding())
                    }
                    ')', ']', '}' -> {
                        indentLevel--
                        stringBuilder.appendLine().append(padding()).append(char)
                    }
                    ',' -> {
                        stringBuilder.appendLine(char).append(padding())
                        // ignore space after comma as we have added a newline
                        val nextChar = string.getOrElse(i + 1) { char }
                        if (nextChar == ' ') i++
                    }
                    else -> {
                        stringBuilder.append(char)
                    }
                }
                i++
            }
            val prettyString = stringBuilder.toString()
            this.info(prettyString)
        }
    }

    private fun logLongString(string: String, action: (String) -> Unit) {
        val length = 1000
        var s = string
        while (s.length > length) {
            var substringIndex = s.lastIndexOf(",", length)
            if (substringIndex == -1) substringIndex = length
            action(s.substring(0, substringIndex))
            s = s.substring(substringIndex).trim { it <= ' ' }
        }
        action(s)
    }
}