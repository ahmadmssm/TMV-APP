plugins {
    id(BuildSystem.plugins.androidApplication)
    kotlin(BuildSystem.plugins.android)
}

val bundleId = "com.teavaro.teavaroMobileApp"

android {

    namespace = bundleId

    defaultConfig {
        applicationId = bundleId
        minSdk = BuildSystem.versions.minSdk
        targetSdk = BuildSystem.versions.compileSdk
        compileSdk = BuildSystem.versions.compileSdk
        versionCode = BuildSystem.versions.versionCode
        versionName = BuildSystem.versions.versionName
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = BuildSystem.versions.kotlinCompilerExtension
    }

    packaging {
        resources.excludes.addAll(
            listOf(
                "lib/armeabi/**",
                "/META-INF/{AL2.0,LGPL2.1}",
                "META-INF/LICENSE.md",
                "META-INF/LICENSE-notice.md",
                "META-INF/common.kotlin_module",
                "META-INF/*.kotlin_module"
            )
        )
    }

    buildTypes {
        getByName(BuildSystem.buildConfig.fieldName.debugBuildType) {
            isMinifyEnabled = false
            applicationIdSuffix = ".debug"
        }
        getByName(BuildSystem.buildConfig.fieldName.releaseBuildType) {
            isMinifyEnabled = true
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    applicationVariants.all {
        outputs.forEach { output ->
            if (output is com.android.build.gradle.internal.api.BaseVariantOutputImpl) {
                // Rename APK
                output.outputFileName = "Teavaro Manga Viewer-v$versionName($versionCode)-${name}.${output.outputFile.extension}"
            }
        }
    }
}

dependencies {
    implementation(project(":kmmSharedModule"))
    implementation(BuildSystem.libraries.composeUI)
    implementation(BuildSystem.libraries.composeTooling)
    implementation(BuildSystem.libraries.composePreview)
    implementation(BuildSystem.libraries.composeFoundation)
    implementation(BuildSystem.libraries.composeMaterial)
    implementation(BuildSystem.libraries.activityCompose)
    //
    implementation(BuildSystem.libraries.ktorOkHttpEngine)
    // Hyperion debugger
    debugImplementation(BuildSystem.libraries.hyperionCore)
    debugImplementation(BuildSystem.libraries.hyperionSharedPreferences)
    releaseImplementation(BuildSystem.libraries.hyperionNoop)
    // FC and UTIQ SDKs
    implementation(BuildSystem.libraries.utiq)
//    implementation(BuildSystem.libraries.funnelConnect) {
//        exclude("com.github.Teavaro.FunnelConnect-Mobile-SDK", "core")
//    }
}