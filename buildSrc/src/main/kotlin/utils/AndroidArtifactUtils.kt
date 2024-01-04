package utils

import java.io.File

object AndroidArtifactUtils {

    fun moveOutputFile(buildType: String, path: String) {
        val extension = ".apk"
        val outputFolderPath = "$path/artifacts/Android/$buildType"
        val originalAPKFilesPath = "$path/androidApp/build/outputs/apk/"
        File(originalAPKFilesPath)
            .walk()
            .filter { item -> item.toString().contains(buildType, true) && item.toString().endsWith(extension) }
            .sortedBy { it.lastModified() }
            .firstOrNull()?.let {
                it.copyTo(File("$outputFolderPath/${it.name}"), overwrite = true)
                it.parentFile.deleteRecursively()
            } ?:
            run {
                println("Invalid APK File Path!")
            }
    }
}