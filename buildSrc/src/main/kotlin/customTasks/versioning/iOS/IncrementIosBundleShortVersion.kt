package customTasks.versioning.iOS

import org.gradle.api.DefaultTask
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.TaskAction
import utils.GradleUtils
import java.io.IOException
import java.nio.charset.Charset
import java.nio.file.Files

// Gradle classes should always be open
open class IncrementIosBundleShortVersion: DefaultTask() {

    @get:Input
    var buildType = BuildType.Development

    @get:Input
    var releaseType = ReleaseType.Minor

    enum class ReleaseType {
        Major, Minor, Fix
    }

    // Must match the .xcconfig files in xCode project
    enum class BuildType {
        Development, Production
    }

    @TaskAction
    fun action() {
        val file = GradleUtils.iOSBuildVersionsFile(this.buildType.name)
        val fileLines = Files.readAllLines(file.toPath(), Charset.defaultCharset()).toMutableList()
        val lineNumber = fileLines.indexOfFirst { it.contains("BUNDLE_SHORT_VERSION", ignoreCase = true) }
        val keyValuePairs = fileLines[lineNumber].split("=")
        val currentVersionCode = keyValuePairs[1].trim()
        val updatedVersionCode = this.getUpdatedVersionName(currentVersionCode)
        fileLines[lineNumber] = keyValuePairs.first().trim() + " = " + updatedVersionCode.toString()
        try {
            Files.write(file.toPath(), fileLines, Charset.defaultCharset())
        }
        catch (e: IOException) {
            println(e)
        }
    }

    private fun getUpdatedVersionName(currentVersionName: String): String {
        val versionParts = currentVersionName.split(".")
        var major = versionParts.first().toInt()
        var minor = versionParts[1].toInt()
        var fix = versionParts[2].toInt()
        when(releaseType) {
            ReleaseType.Major -> {
                major += 1
                minor = 0
                fix = 0
            }
            ReleaseType.Minor -> {
                minor += 1
                fix = 0
            }
            ReleaseType.Fix -> fix += 1
        }
        return "$major.$minor.$fix"
    }
}