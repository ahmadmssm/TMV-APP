buildscript {

    repositories {
        gradlePluginPortal()
        google()
        mavenLocal()
        mavenCentral()
        maven("https://jitpack.io")
    }

    dependencies {
        classpath(BuildSystem.classPaths.kotlin)
        classpath(BuildSystem.classPaths.gradle)
        classpath(BuildSystem.classPaths.realm)
    }
}

allprojects {

    repositories {
        google()
        mavenLocal()
        mavenCentral()
        maven("https://jitpack.io")
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_17.toString()
        }
    }
}

subprojects {

    apply {
        from("$rootDir/iOSTasks.gradle.kts")
        from("$rootDir/androidTasks.gradle.kts")
    }

    repositories {
        mavenCentral()
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}