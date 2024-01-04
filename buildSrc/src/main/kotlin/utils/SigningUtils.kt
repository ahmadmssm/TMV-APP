package utils

import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.file.Files
import java.util.*

object SigningUtils {

    // Please don't alter these paths because there are many functions depends on the these paths to be correct.
    private val jksFilePath by lazy { "/secrets/SigningKey.jks" }
    private val signingConfigsFilePath by lazy { "/secrets/keystore.properties" }

    fun createJKSFile(encodedDescription: String) {
        val jksFile = File(jksFilePath)
        try {
            FileOutputStream(jksFile).use { fos ->
                val decoder = Base64.getDecoder().decode(encodedDescription)
                fos.write(decoder)
                println("JKS file saved")
            }
        }
        catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun writeKeyAlias(alias: String) {
        GradleUtils.updatePropertiesFileField(signingConfigsFilePath, "keyAlias", alias)
    }

    fun writeKeyPassword(password: String) {
        GradleUtils.updatePropertiesFileField(signingConfigsFilePath, "keyPassword", password)
    }

    fun writeStorePassword(password: String) {
        GradleUtils.updatePropertiesFileField(signingConfigsFilePath, "storePassword", password)
    }

    fun deleteSigningData() {
        deleteJKSFile()
        GradleUtils.updatePropertiesFileField(signingConfigsFilePath, "keyAlias", "")
        GradleUtils.updatePropertiesFileField(signingConfigsFilePath, "keyPassword", "")
        GradleUtils.updatePropertiesFileField(signingConfigsFilePath, "storePassword", "")
    }

    private fun deleteJKSFile() {
        val jksFile = File(jksFilePath)
        Files.deleteIfExists(jksFile.toPath())
    }

    fun getAPKSigningSigningConfigsFromEnvVars(rootProjectPath: String): SigningConfigs {
        var keyAlias = System.getenv("KEY_ALIAS")
        var keyPassword = System.getenv("KEY_PASSWORD")
        var storePassword = System.getenv("STORE_PASSWORD")
        if (keyAlias == null && keyPassword == null && storePassword == null) {
            val inputStream = FileInputStream(rootProjectPath + signingConfigsFilePath)
            val props = Properties()
            props.load(inputStream)
            inputStream.close()
            //
            keyAlias = props["keyAlias"] as String
            keyPassword = props["keyPassword"] as String
            storePassword = props["storePassword"] as String
        }
        val storeFile = File(rootProjectPath + jksFilePath)
        return SigningConfigs(storeFile, keyAlias, keyPassword, storePassword)
    }
}