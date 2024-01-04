import java.util.Properties

plugins {
    id(BuildSystem.plugins.androidLibrary)
    id(BuildSystem.plugins.ksp).version(BuildSystem.versions.ksp)
    id(BuildSystem.plugins.ktorfit).version(BuildSystem.versions.ktorfit)
    id(BuildSystem.plugins.buildKonfig).version(BuildSystem.versions.buildKonfig)
    id(BuildSystem.plugins.realm)
    kotlin(BuildSystem.plugins.kotlinMultiplatform)
    kotlin(BuildSystem.plugins.kotlinSerialization).version(BuildSystem.versions.kotlin)
}

val sdkName = "kmmSharedModule"
val sdkPackageName = "com.teavaro.$sdkName"

@OptIn(org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi::class)
kotlin {

    targetHierarchy.default()

    androidTarget {
        compilations.all {
            kotlinOptions {
                jvmTarget = Versions.jvmTarget
            }
        }
    }

    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach {
        it.binaries.framework {
            baseName = sdkName
            isStatic = true
        }
    }

    sourceSets {

        val commonMain by getting {
            dependencies {
                implementation(BuildSystem.libraries.ktorCore)
                implementation(BuildSystem.libraries.ktorContentNegotiation)
                implementation(BuildSystem.libraries.ktorJson)
                implementation(BuildSystem.libraries.ktorLogging)
                implementation(BuildSystem.libraries.ktorSerialization)
                implementation(BuildSystem.libraries.kotlinSerialization)
                implementation(BuildSystem.libraries.kotlinAtomicity)
                implementation(BuildSystem.libraries.coroutines)
                implementation(BuildSystem.libraries.ktorfit)
                implementation(BuildSystem.libraries.kotlinxDatetime)
                implementation(BuildSystem.libraries.realm)
            }
        }

        val commonTest by getting {
            dependencies {
                implementation(kotlin("test"))
            }
        }

        val androidMain by getting {
            dependencies {
                // Chucker Logger
                implementation(BuildSystem.libraries.chucker)
                implementation(BuildSystem.libraries.ktorOkHttpEngine)
                implementation(BuildSystem.libraries.okhttpLoggingInterceptor)
            }
        }
    }
}

android {

    namespace = sdkPackageName

    defaultConfig {
        minSdk = BuildSystem.versions.minSdk
        compileSdk = BuildSystem.versions.compileSdk
        consumerProguardFiles("proguard-rules.pro")

    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

buildkonfig {

    val string = com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING

    packageName = sdkPackageName
    exposeObjectWithName = "BuildKonfig"

    val properties = Properties().apply {
        load(rootProject.file("secrets/sdks.properties").reader())
    }

    defaultConfigs {
        buildConfigField(string, "baseURL", "https://api.mangadex.org/")
        buildConfigField(string, "imageBaseURL", "https://uploads.mangadex.org/covers/")
        buildConfigField(string, "utiqToken", if (properties.containsKey("utiqToken")) properties["utiqToken"] as String else "123")
        buildConfigField(string, "funnelConnectToken", if (properties.containsKey("funnelConnectToken")) properties["funnelConnectToken"] as String else "123")
        buildConfigField(string, "supportEmail", if (properties.containsKey("supportEmail")) properties["supportEmail"] as String else "")
    }

    targetConfigs {
        val commonMain by creating
        val commonTest by creating
    }
}

dependencies {
    listOf("kspCommonMainMetadata", "kspAndroid", "kspIosX64", "kspIosArm64", "kspIosSimulatorArm64").forEach {
        add(it, BuildSystem.libraries.ktorfitKSP)
    }
}
