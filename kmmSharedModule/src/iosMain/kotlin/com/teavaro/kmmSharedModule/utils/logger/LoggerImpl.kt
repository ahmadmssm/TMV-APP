package com.teavaro.kmmSharedModule.utils.logger

actual class LoggerImpl actual constructor(private val enableLogging: Boolean) : SystemLogger {

    @Suppress("PrivatePropertyName")
    private val TAG = "Teavaro Manga App: "

    override fun log(string: String) {
        if (enableLogging)
            println(TAG + string)
    }

    override fun log(tag: String, string: String) {
        if (enableLogging)
            println(tag + string)
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
            this.log(prettyString)
        }
    }
}